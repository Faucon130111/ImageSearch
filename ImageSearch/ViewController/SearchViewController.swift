//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/08.
//

import ReactorKit
import RxCocoa
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
        // View
        collectionView.rx.itemSelected
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
        
        // Action
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filterEmpty()
            .do(onNext: { [unowned self] _ in
                self.collectionView.setContentOffset(.zero, animated: false)
            })
            .map(Reactor.Action.updateQuery)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.contentOffset
            .filter { [unowned self] offset in
                guard self.collectionView.frame.height > 0
                else {
                    return false
                }
                return offset.y + self.collectionView.frame.height >= self.collectionView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.imageModels }
            .filterNil()
            .distinctUntilChanged()
            .do(onNext: { [unowned self] imageModels in
                let message = imageModels.isEmpty ? "검색 결과가 없습니다." : nil
                self.collectionView.showEmptyMessage(message)
            })
            .bind(to: collectionView.rx.items(cellIdentifier: "ImageCell")) { (row, model, cell) in
                let imageCell = cell as? ImageCell
                imageCell?.imageModel = model
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoadingNextPage }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] isLoading in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
}

