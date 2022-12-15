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
        view.backgroundColor = Colors.navy
        self.title = "List"
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(addNewTodoListForToday))
        navigationItem.rightBarButtonItem?.tintColor = Colors.white
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.white]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
     @objc func addNewTodoListForToday() {
         let todoDetailVC = TodoDetailVC()
         navigationController?.pushViewController(todoDetailVC, animated: true)
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 60
        tableView.backgroundColor = Colors.navy
        tableView.separatorColor = Colors.white
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
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let todoListToDelete = todoList[indexPath.row]
        
        let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?\n관련된 모든 데이터가 삭제됩니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in return })
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { action in
            // MARK: DB에서 삭제
            self.removeTodoList(todoList: todoListToDelete)
            // MARK: TableView 및 todoList 배열에서 삭제
            self.todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
