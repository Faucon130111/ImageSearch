//
//  UICollectionView+Extension.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/10.
//

import UIKit

extension UICollectionView {
    
    func showEmptyMessage(_ message: String?) {
        guard let message = message
        else {
            self.backgroundView = nil
            return
        }
        
        let label = UILabel(frame: self.bounds)
        label.text = message
        label.textAlignment = .center
        self.backgroundView = label
    }
    
}
