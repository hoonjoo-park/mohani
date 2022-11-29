//
//  TodoDetailVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit
import CoreData

class TodoDetailVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoInfo: TodoList? = nil
    var tasks: [Task] = []
    var today = Date().toYearMonthDate()
    var isTodoNew = true
    
    let scrollView = UIScrollView()
    let progressView = UIView()
    let tableTitleLabel = UILabel()
    let tableView = UITableView()
    let addTaskButton = UIButton()
    var UIViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTodoInfo(date: today)
        fetchTasks(date: today)
        
        configureViewController()
        configureTableView()
        configureUI()
    }
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.title = today
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseId)
    }
    
    
    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubviews(progressView ,tableTitleLabel, tableView, addTaskButton)
        
        scrollView.pinToEdges(superView: view)
        add(childVC: ProgressVC(tasks: tasks), containerView: progressView)
        
        UIViews = [progressView, tableTitleLabel, tableView, addTaskButton]
        
        tableTitleLabel.text = "Todo"
        addTaskButton.backgroundColor = .blue
        addTaskButton.layer.cornerRadius = 50
        
        for view in UIViews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            progressView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            progressView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            
            tableTitleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 40),
            tableTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            
            tableView.topAnchor.constraint(equalTo: tableTitleLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            
            addTaskButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -padding),
            addTaskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            addTaskButton.widthAnchor.constraint(equalToConstant: 60),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func add(childVC: UIViewController, containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    private func fetchTodoInfo(date: String) {
        let fetchRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchRequest.predicate = predicate
        
        do {
            let todo = try context.fetch(fetchRequest)

            guard todo.count > 0 else {
                let newTodoInfo = TodoList(context: context)
                newTodoInfo.createdAt = date

                self.todoInfo = newTodoInfo
                try self.context.save()
                return
            }

            todoInfo = todo[0]
            isTodoNew = false
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
        }
    }

    
    private func fetchTasks(date: String) {
        guard !self.isTodoNew else { return }
        
        let fetchRequest = Task.fetchRequest() as NSFetchRequest<Task>
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            guard tasks.count > 0 else { return }
            
            self.tasks = tasks
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
        }
    }
    
    
}

extension TodoDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.reuseId) as! TaskCell
        let task = tasks[indexPath.row]
        cell.setCell(task: task)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
}
