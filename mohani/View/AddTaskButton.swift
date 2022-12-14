//
//  AddTaskButton.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class AddTaskButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = Colors.blue.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.20
        
        configuration = .filled()
        configuration?.title = "추가"
        configuration?.baseBackgroundColor = Colors.blue
        configuration?.baseForegroundColor = Colors.white
        configuration?.cornerStyle = .capsule
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 150),
            heightAnchor.constraint(equalToConstant: 40),
        ])
    }

}
