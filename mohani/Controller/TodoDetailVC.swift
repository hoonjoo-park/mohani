//
//  TodoDetailVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit

protocol TodoDetailVCDelegate: AnyObject {
    func onChangeTask(tasks: [Task])
}

class TodoDetailVC: UIViewController {
    enum Section { case main }
    
    weak var delegate: TodoDetailVCDelegate!
    var todoInfo: TodoList? = nil
    var tasks: [Task] = []
    var currentDate = Date().toYearMonthDate()
    var isTodoNew = true
    var dataSource: UICollectionViewDiffableDataSource<Section, Task>!
    
    let progressView = UIView()
    let tableTitleLabel = TitleLabel(color: Colors.black)
    let addTaskButton = PlusButton(frame: .zero)
    var collectionView: UICollectionView!
    let emptyTaskView = TitleLabel(color: Colors.gray)
    var UIViews: [UIView] = []
    
    init(date: String = Date().toYearMonthDate()) {
        super.init(nibName: nil, bundle: nil)
        self.currentDate = date
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTodoInfo(date: currentDate)
        configureTasks(date: currentDate)
        
        configureEmptyTaskView()
        configureViewController()
        configureProgressView()
        configureCollectionView()
        configureDataSource()
        configureAddTaskButton()
        configureUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    private func configureTodoInfo(date: String) {
        let todo = fetchTodoListInfo(date: currentDate)
        
        guard todo.count > 0 else { return }
        
        todoInfo = todo[0]
        isTodoNew = false
    }

    
    private func configureTasks(date: String) {
        guard !self.isTodoNew else { return }

        let tasks = fetchTasks(date: currentDate)

        guard tasks.count > 0 else { return }
        
        self.tasks = tasks
        self.updateTasks()
    }
    
    
    private func configureViewController() {
        let listButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(onTappedListButton))
        
        view.backgroundColor = Colors.blueWhite
        navigationItem.leftBarButtonItem = listButton
        navigationItem.leftBarButtonItem?.tintColor = Colors.black
    }
    
    
    private func configureProgressView() {
        let progressVC = ProgressVC(title: currentDate, tasks: tasks)
        add(childVC: progressVC, containerView: progressView)
        self.delegate = progressVC
        
        let shadowColor = Colors.black.cgColor
        progressView.layer.shadowColor = shadowColor
        progressView.layer.shadowOpacity = 0.15
        progressView.layer.shadowOffset = .zero
        progressView.layer.shadowRadius = 10
    }
    
    private func configureEmptyTaskView() {
        emptyTaskView.text = "등록된 할 일이 없습니다."
        emptyTaskView.textAlignment = .center
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createTaskCellLayout(view: view))
        collectionView.delegate = self
        collectionView.backgroundColor = Colors.blueWhite
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.reuseId)
        
        if tasks.count == 0 {
            collectionView.backgroundView = emptyTaskView
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Task>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.reuseId, for: indexPath) as! TaskCell
            cell.setCell(task: self.tasks[indexPath.row], indexPath: indexPath)
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
    
    
    private func updateTasks() {
        sortTasksByIsDone()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(self.tasks)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    private func sortTasksByIsDone() {
        tasks.sort { return !$0.isDone && $1.isDone }
    }
    
    
    @objc func onTappedListButton() {
        let todoListVC = TodoListVC()
        navigationController?.pushViewControllerFromLeftToRight(viewController: todoListVC)
    }
    
    
    @objc func onTappedAddTaskButton() {
        let TaskInputVC = TaskInputVC()
        TaskInputVC.modalPresentationStyle = .pageSheet
        TaskInputVC.delegate = self
        
        if let bottomSheet = TaskInputVC.sheetPresentationController {
            bottomSheet.detents = [.custom(resolver: { context in
                return 450
            })]
            bottomSheet.prefersGrabberVisible = true
        }
        
        present(TaskInputVC, animated: true)
    }
}


extension TodoDetailVC: UICollectionViewDelegate {}



extension TodoDetailVC: TaskInputVCDelegate {
    func onAddTask(title: String) {
        guard delegate != nil else { return }
        
        addTask(title: title, createdAt: currentDate)
        configureTasks(date: currentDate)
        delegate.onChangeTask(tasks: tasks)
    }
}


extension TodoDetailVC: TaskCellDelegate {
    func onToggleIsDone(task: Task) {
        guard delegate != nil else { return }
        
        saveContext()
        delegate.onChangeTask(tasks: tasks)
        sortTasksByIsDone()
        updateTasks()
    }
    
    
    func onTapDeleteTask(indexPath: IndexPath) {
        guard delegate != nil else { return }
        let taskToDelete = tasks[indexPath.row]
        
        let alert = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default) { _ in return })
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { action in
            // MARK: DB에서 삭제
            self.removeTask(task: taskToDelete)
            // MARK: TableView 및 todoList 배열에서 삭제
            self.tasks.remove(at: indexPath.row)
            self.updateTasks()

            self.showToastMessage(message: "삭제가 완료되었습니다!", status: .success, withKeyboard: false)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func onSwipeCell(indexPath: IndexPath) {
        let visibleCells = collectionView.visibleCells
        let currentCell = visibleCells[indexPath.row]
        
        for cell in visibleCells {
            if cell == currentCell { continue }
            
            let cellContainer = cell.subviews[0]
            let deleteButton = cell.subviews[1]

            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
                    cellContainer.transform = .identity
                }
                
                deleteButton.alpha = 0
            }
        }
    }
}
