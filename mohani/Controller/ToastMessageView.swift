//
//  ToastMessageVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/07.
//

import UIKit

class ToastMessageView: UIView {
    
    var toastImage = UIImageView()
    let toastMessageTextLabel = BodyLabel(color: Colors.white)
    
    
    init(frame: CGRect ,message: String, status: ToastStatus) {
        super.init(frame: frame)
        
        toastMessageTextLabel.text = message
        
        switch status {
        case .success:
            toastImage.image = UIImage(systemName: "checkmark.circle.fill")
            toastImage.tintColor = Colors.green
        case .error:
            toastImage.image = UIImage(systemName: "xmark.seal.fill")
            toastImage.tintColor = .systemRed
        case .warning:
            toastImage.image = UIImage(systemName: "exclamationmark.triangle.fill")
            toastImage.tintColor = .systemYellow
        }
        
        configureContainerUI()
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureContainerUI() {
//        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = Colors.darkGray
        layer.cornerRadius = 8
        addSubviews(toastImage, toastMessageTextLabel)
    }
    
    private func configureUI() {
        let padding: CGFloat = 20
        
        toastImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - (padding * 2)),
//            self.heightAnchor.constraint(equalToConstant: 52),
            
            toastImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            toastImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            toastImage.widthAnchor.constraint(equalToConstant: 25),
            toastImage.heightAnchor.constraint(equalToConstant: 25),
            
            toastMessageTextLabel.leadingAnchor.constraint(equalTo: toastImage.trailingAnchor, constant: 12),
            toastMessageTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            toastMessageTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
