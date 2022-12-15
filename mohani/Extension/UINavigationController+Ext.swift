//
//  UINavigationController+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/15.
//

import UIKit

extension UINavigationController {
    func pushViewControllerFromLeftToRight(viewController: UIViewController) {
        let transition = CATransition()
        
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(viewController, animated: false)
    }
}
