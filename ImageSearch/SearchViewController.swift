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

class SearchViewController: UIViewController, StoryboardView {

    typealias Reactor = SearchViewReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: SearchViewReactor) {
        searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.isEmpty == false }
            .subscribe(onNext: { query in
                print("### query: \(query)")
            })
            .disposed(by: disposeBag)
        
        view.rx.anyGesture(
            .tap(),
            .swipe(direction: .up),
            .swipe(direction: .down)
        )
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
        })
        .disposed(by: disposeBag)
    }
    
}

