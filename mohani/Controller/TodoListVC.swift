//
//  TodoList.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit

class TodoListVC: UIViewController {
    var todoList: [TodoList] = []
    
    var tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureTodoList()
    }
    
    
    private func configureTodoList() {
        todoList = fetchAllTodoList()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.bringSubviewToFront(self.tableView)
        }
    }
    
    
    private func configureViewController() {
        view.backgroundColor = Colors.gray
        self.title = "List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 60
        tableView.backgroundColor = Colors.gray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.removeExcessCells()
        
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseID)
    }
}


extension TodoListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.reuseID) as! TodoListCell
        let todoList = todoList[indexPath.row]
        cell.setCell(todoList: todoList)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDate = todoList[indexPath.row].createdAt!
        
        let todoDetailVC = TodoDetailVC(date: selectedDate)
        navigationController?.pushViewController(todoDetailVC, animated: true)
    }
}
