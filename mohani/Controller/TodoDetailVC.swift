//
//  TodoDetailVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit
import CoreData

class TodoDetailVC: UIViewController {
    enum Section { case main }
    
    var todoInfo: TodoList? = nil
    var tasks: [Task] = []
    var today = Date().toYearMonthDate()
    var isTodoNew = true
    var dataSource: UICollectionViewDiffableDataSource<Section, Task>!
    
    let progressView = UIView()
    let tableTitleLabel = TitleLabel(color: Colors.black)
    let addTaskButton = PlusButton(frame: .zero)
    var collectionView: UICollectionView!
    var UIViews: [UIView] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTodoInfo(date: today)
        configureTasks(date: today)
        
        configureViewController()
        configureProgressView()
        configureCollectionView()
        configureDataSource()
        configureAddTaskButton()
        configureUI()
    }
    
    
    private func configureTodoInfo(date: String) {
        let todo = fetchTodoListInfo(date: today)
        
        guard todo.count > 0 else { return }
        
        todoInfo = todo[0]
        isTodoNew = false
    }

    
    private func configureTasks(date: String) {
        guard !self.isTodoNew else { return }

        let tasks = fetchTasks(date: today)

        guard tasks.count > 0 else { return }
        
        self.tasks.append(contentsOf: tasks)
        self.updateTasks(tasks: tasks)
    }
    
    
    private func configureViewController() {
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(onTappedListButton))
        
        view.backgroundColor = Colors.blueWhite
        navigationItem.leftBarButtonItem = listButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.black
    }
    
    
    private func configureProgressView() {
        add(childVC: ProgressVC(title: today, tasks: tasks), containerView: progressView)
        
        let shadowColor = Colors.black.cgColor
        progressView.layer.shadowColor = shadowColor
        progressView.layer.shadowOpacity = 0.15
        progressView.layer.shadowOffset = .zero
        progressView.layer.shadowRadius = 10
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTaskCellLayout(view: view))
        collectionView.delegate = self
        collectionView.backgroundColor = Colors.blueWhite
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.reuseId)
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Task>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.reuseId, for: indexPath) as! TaskCell
            cell.setCell(task: self.tasks[indexPath.row])
            cell.delegate = self
            
            return cell
        })
    }
    
    
    private func configureAddTaskButton() {
        addTaskButton.addTarget(self, action: #selector(onTappedAddTaskButton), for: .touchUpInside)
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 20
        view.addSubviews(progressView ,tableTitleLabel, collectionView, addTaskButton)
        
        tableTitleLabel.text = "Todo"
        
        UIViews = [progressView, tableTitleLabel, collectionView, addTaskButton]
        for view in UIViews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            progressView.heightAnchor.constraint(equalToConstant: 130),
            
            tableTitleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 40),
            tableTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            collectionView.topAnchor.constraint(equalTo: tableTitleLabel.bottomAnchor, constant: 15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
    
    
    private func add(childVC: UIViewController, containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    private func updateTasks(tasks: [Task]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections([.main])
        snapshot.appendItems(tasks)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    @objc func onTappedListButton() {
        // TODO: TodoListVC로 네비게이션 이동되는 로직 구현 필요
        return
    }
    
    
    @objc func onTappedAddTaskButton() {
        let TaskInputVC = TaskInputVC()
        TaskInputVC.modalPresentationStyle = .pageSheet
        TaskInputVC.delegate = self
        
        if let bottomSheet = TaskInputVC.sheetPresentationController {
            bottomSheet.detents = [.custom(resolver: { context in
                return 600
            }), .large()]
            bottomSheet.prefersGrabberVisible = true
        }
        
        present(TaskInputVC, animated: true)
        return
    }
}


extension TodoDetailVC: UICollectionViewDelegate {
    
}



extension TodoDetailVC: TaskInputVCDelegate {
    func onAddTask(title: String) {
        addTask(title: title, createdAt: today)
        configureTasks(date: today)
        return
    }
}


extension TodoDetailVC: TaskCellDelegate {
    func onToggleIsDone(task: Task) {
        saveContext()
        return
    }
}
