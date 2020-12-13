//
//  ImageDetailViewController.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import UIKit

import ReactorKit
import RxCocoa
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
    @IBOutlet weak fileprivate var dateTimeLabel: UILabel!
    @IBOutlet weak fileprivate var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: ReactorKit
    func bind(reactor: ImageDetailViewReactor) {
        // View
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.loadImageDetail }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Action
        closeButton.rx.tap
            .map { Reactor.Action.closeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.imageHeight }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: imageViewHeightConstraint.rx.constant)
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
            .bind(to: displaySiteNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dateTime }
            .filterNil()
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .bind(to: dateTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.dismiss }
            .filter { $0 == true }
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)
    }
    
}
