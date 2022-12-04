//
//  TaskProgressView.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/04.
//

import UIKit

class TaskProgressView: UIProgressView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.blueWhite
        progress = 0.0
        clipsToBounds = true
        layer.cornerRadius = 7.5
        layer.sublayers![1].cornerRadius = 7.5
        subviews[1].backgroundColor = Colors.blue
        subviews[1].clipsToBounds = true
    }
}
