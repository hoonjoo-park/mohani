//
//  ToastMessageView.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/07.
//

import UIKit

class ToastMessageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.darkGray
        layer.cornerRadius = 15
    }
}
