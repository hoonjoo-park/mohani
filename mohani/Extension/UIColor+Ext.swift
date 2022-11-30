//
//  UIColor+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
