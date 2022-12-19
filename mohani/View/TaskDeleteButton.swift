//
//  TaskDeleteButton.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/19.
//

import UIKit

class TaskDeleteButton: UIButton {
    
    let deleteImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        deleteImage.image = UIImage(systemName: "trash.fill")
        deleteImage.tintColor = .red
        deleteImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            deleteImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteImage.widthAnchor.constraint(equalToConstant: 30),
            deleteImage.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

}
