//
//  ImageCell.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import RxCocoa
import RxKingfisher
import RxSwift

class ImageCell: UICollectionViewCell {
    
    var documentModel: DocumentModel! {
        didSet {
            imageView.loadImage(documentModel.thumbnail_url)
        }
    }
    
    @IBOutlet weak fileprivate var imageView: UIImageView!
    
}
