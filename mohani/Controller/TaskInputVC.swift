//
//  TaskInputVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class TaskInputVC: UIViewController {
    let textField = TaskTextField(placeholder: "오늘 할 일을 입력해 주세요.")
    let addButton = AddTaskButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        configureUI()
    }
    
    private func configureUI() {
        let padding:CGFloat = 35
        view.addSubviews(textField, addButton)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textField.heightAnchor.constraint(equalToConstant: 25),
            
            addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 55),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        ])
    }
}
