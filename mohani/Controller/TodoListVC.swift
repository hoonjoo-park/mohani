//
//  TodoList.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit

class TodoListVC: UIViewController {
    let todoList: [TodoList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.gray
        self.title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
