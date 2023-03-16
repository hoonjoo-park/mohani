//
//  UIViewController+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/01.
//

import UIKit
import CoreData

extension UIViewController {
    func showToastMessage(message: String, status: ToastStatus, withKeyboard: Bool) {
        var startY: CGFloat
        var targetY: CGFloat
        
        let padding: CGFloat = 20
        let toastHeight: CGFloat = 52
        let toastWidth: CGFloat = UIScreen.main.bounds.width - 2 * padding
        
        if withKeyboard {
            startY = (UIScreen.main.bounds.height / 2) + (toastHeight / 2)
            targetY = UIScreen.main.bounds.height / 2 - toastHeight
        } else {
            startY = UIScreen.main.bounds.height + toastHeight
            targetY = UIScreen.main.bounds.height - (toastHeight * 2)
        }
        
        let frame = CGRect(x: padding, y: startY, width: toastWidth, height: toastHeight)
        let toastMessageView = ToastMessageView(frame: frame, message: message, status: status)
        
        DispatchQueue.main.async {
            self.view.addSubview(toastMessageView)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                toastMessageView.frame = CGRect(x: padding, y: targetY, width: toastWidth, height: toastHeight)
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            toastMessageView.removeFromSuperview()
        }
    }
    
    
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.viewWillAppear(true)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
