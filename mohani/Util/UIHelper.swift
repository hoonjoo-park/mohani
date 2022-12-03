//
//  UIHelper.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

enum Colors {
    static let blueWhite = UIColor(r: 244, g: 246, b: 253)
    static let white = UIColor(r: 255, g: 255, b: 255)
    static let blue = UIColor(r: 7, g: 117, b: 255)
    static let black = UIColor(r: 2, g: 4, b: 23)
    static let gray = UIColor(r: 165, g: 171, b: 195)
}


enum UIHelper {
    static func createTaskCellLayout(view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let itemSpacing: CGFloat = 5
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: itemSpacing, left: 0, bottom: itemSpacing, right: 0)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 50)
        
        return flowLayout
    }
}
 
