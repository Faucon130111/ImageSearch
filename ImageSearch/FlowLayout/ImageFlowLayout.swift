//
//  ImageFlowLayout.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import UIKit

class ImageFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        
        let spacing: CGFloat = 1.0
        let columnCount = 3
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - CGFloat((columnCount + 1)) * spacing) / 3.0
        
        itemSize = .init(
            width: width,
            height: width
        )
        
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        
        sectionInset = .init(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
    }
    
}
