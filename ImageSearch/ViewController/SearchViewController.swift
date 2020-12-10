//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit
import RxCocoa
import RxGesture
import RxOptional
import RxSwift

class SearchViewController: UIViewController, Storyboarded, StoryboardView {

    // MARK: Variables
    typealias Reactor = SearchViewReactor
    var disposeBag = DisposeBag()
    
    // MARK: UI
    @IBOutlet weak fileprivate var searchBar: UISearchBar!
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    // MARK: ReactorKit
    func bind(reactor: SearchViewReactor) {
        view.rx.anyGesture(
            .swipe(direction: .up),
            .swipe(direction: .down)
        )
        .subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
        })
        .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .do(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .map { reactor.reactorForImageDetail($0) }
            .subscribe(onNext: { [unowned self] reactor in
                let imageDetailViewController = ImageDetailViewController.instantiate()
                imageDetailViewController.reactor = reactor
                imageDetailViewController.modalPresentationStyle = .fullScreen

                self.present(
                    imageDetailViewController,
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .map { [unowned self] _ in self.isEndOfScroll() }
            .filter { $0 == true }
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .do(onNext: { _ in print("### didScroll") })
            .map { _ in Reactor.Action.scrollReachedEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filterEmpty()
            .do(onNext: { print("### text: \($0)") })
            .map(Reactor.Action.requestSearchImages)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.documentModels }
            .distinctUntilChanged()
            .do(onNext: { print("### count: \($0.count)") })
            .bind(to: collectionView.rx.items(cellIdentifier: "ImageCell")) { (row, model, cell) in
                guard let imageCell = cell as? ImageCell
                else {
                    return
                }
                imageCell.documentModel = model
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.page }
            .distinctUntilChanged()
            .filter { $0 > 0 }
            .do(onNext: { print("### page: \($0)") })
            .map { _ in Reactor.Action.fetchImages }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .do(onNext: { print("### isLoading: \($0)") })
            .subscribe(onNext: { [unowned self] isLoading in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Fileprivate Function
    fileprivate func isEndOfScroll() -> Bool {
        let offset: CGFloat = 200.0
        let bottomEdge = self.collectionView.contentOffset.y + self.collectionView.frame.size.height;
        return bottomEdge + offset >= self.collectionView.contentSize.height
    }
    
}

