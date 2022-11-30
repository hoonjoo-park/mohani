//
//  TaskTextField.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class TaskTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.attributedPlaceholder = NSMutableAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : Colors.gray])
        configure()
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = Colors.white
        textColor = Colors.black
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 16
        clearButtonMode = .whileEditing
        returnKeyType = .done
        
        autocorrectionType = .no
        autocapitalizationType = .none
    }
}
