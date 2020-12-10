//
//  UIImageView+Extension.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: urlString))
    }
    
}
