//
//  PlusButton.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class PlusButton: UIButton {
    var plusImage = UIImage(systemName: "plus")

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
        layer.shadowRadius = 15
        layer.shadowOpacity = 0.30
        
        configuration = .filled()
        configuration?.image = plusImage
        configuration?.baseBackgroundColor = Colors.blue
        configuration?.baseForegroundColor = Colors.white
        configuration?.cornerStyle = .capsule
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 60),
            heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
