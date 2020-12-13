//
//  ImageCell.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import RxCocoa
import RxSwift

class ImageCell: UICollectionViewCell {
    
    var imageModel: ImageModel! {
        didSet {
            imageView.loadImage(imageModel.thumbnail_url)
        }
    }
    
    @IBOutlet weak fileprivate var imageView: UIImageView!
    
}
