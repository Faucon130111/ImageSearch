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
    
    // MARK: ReactorKit
    func bind(reactor: SearchViewReactor) {
        view.rx.anyGesture(
            .swipe(direction: .up),
            .swipe(direction: .down)
        )
        .observeOn(MainScheduler.instance)
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
        
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.isEmpty == false }
            .map { Reactor.Action.searchImages($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.documentModels }
            .bind(to: collectionView.rx.items(cellIdentifier: "ImageCell")) { (row, model, cell) in
                guard let imageCell = cell as? ImageCell
                else {
                    return
                }
                imageCell.documentModel = model
            }
            .disposed(by: disposeBag)
    }
    
}

