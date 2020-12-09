//
//  ImageDetailViewController.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import UIKit

import ReactorKit
import RxCocoa
import RxGesture
import RxSwift
import RxViewController

class ImageDetailViewController: UIViewController, Storyboarded, StoryboardView {
    
    // MARK: Variables
    typealias Reactor = ImageDetailViewReactor
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: UI
    @IBOutlet weak fileprivate var closeButton: UIButton!
    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak fileprivate var displaySiteNameLabel: UILabel!
    @IBOutlet weak fileprivate var dateTimeNameLabel: UILabel!
    
    // MARK: ReactorKit
    func bind(reactor: ImageDetailViewReactor) {
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.loadImageDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.imageURL }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] imageURL in
                self.imageView.loadImage(imageURL)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.displaySiteName }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] displaySiteName in
                self.displaySiteNameLabel.text = displaySiteName
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dateTime }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] dateTime in
                self.dateTimeNameLabel.text = dateTime
            })
            .disposed(by: disposeBag)
    }
    
}
