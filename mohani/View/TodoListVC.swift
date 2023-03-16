//
//  TodoList.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit
import RxSwift
import RxCocoa

class TodoListVC: UIViewController {
    let disposeBag = DisposeBag()
    let currentDate = Date().toYearMonthDate()
    var todoListVM: TodoListViewModel!
    
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
        todoListVM = TodoListViewModel(createdAt: currentDate)
        
        todoListVM.todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoListCell.reuseID, cellType: TodoListCell.self)) { (row, todo, cell) in
                cell.setCell(todoList: todo)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                do {
                    if let selectedDate = try self?.todoListVM.todoList.value()[indexPath.row].createdAt! {
                        let todoDetailVC = TodoDetailVC(date: selectedDate)
                        self?.navigationController?.pushViewController(todoDetailVC, animated: true)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            do {
                if let todoListToDelete = try self?.todoListVM.todoList.value()[indexPath.row] {
                    let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?\n관련된 모든 데이터가 삭제됩니다.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in return })
                    alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { action in
                        self?.todoListVM.removeTodoList(todoList: todoListToDelete)
                        self?.showToastMessage(message: "삭제가 완료되었습니다!", status: .success, withKeyboard: false)
                    })
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            } catch {
                print("Error: \(error)")
            }
        }).disposed(by: disposeBag)
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
        tableView.delegate = self
        tableView.removeExcessCells()
        
        tableView.register(TodoListCell.self, forCellReuseIdentifier: TodoListCell.reuseID)
    }
}


extension TodoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
