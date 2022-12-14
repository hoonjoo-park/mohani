//
//  TaskInputVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

protocol TaskInputVCDelegate: AnyObject {
    func onAddTask(title: String)
}

class TaskInputVC: UIViewController {
    weak var delegate: TaskInputVCDelegate!
    
    let textField = TaskTextField(placeholder: "오늘 할 일을 입력해 주세요.")
    let addButton = AddTaskButton(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureAddButtonAction()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func configureViewController() {
        view.backgroundColor = Colors.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTappedViewController))
        tapGestureRecognizer.numberOfTapsRequired = 1
        view?.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onTappedViewController() {
        view.hideKeyboard()
    }
    
    
    func configureAddButtonAction() {
        addButton.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
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
    
    
    @objc func onAddButtonTapped() {
        guard let taskValue = textField.text, taskValue.count > 0 else { return }
        guard delegate != nil else { return }
        
        delegate.onAddTask(title: taskValue)
        textField.text = ""
        
        showToastMessage(message: "할 일이 추가되었습니다!", status: .success, withKeyboard: true)
        
        return
    }
}
