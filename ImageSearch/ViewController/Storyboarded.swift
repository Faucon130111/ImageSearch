//
//  Storyboarded.swift
//  ImageSearch
//
//  Created by 박본혁 on 2020/12/09.
//

import UIKit

protocol Storyboarded: NSObject {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(
            name: "Main",
            bundle: Bundle.main
        )
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
    
}
