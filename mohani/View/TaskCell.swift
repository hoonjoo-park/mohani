//
//  TaskCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func onToggleIsDone(task: Task)
    func onTapDeleteTask(indexPath: IndexPath)
}

class TaskCell: UICollectionViewCell {
    static let reuseId = "TaskCell"
    
    var checkBoxButton = UIImageView()
    var cellView = UIView()
    var taskDeleteButton = UIImageView()
    let bodyLabel = BodyLabel(color: Colors.black)
    
    var delegate: TaskCellDelegate!
    var prevTranslateX: Double = 0
    
    var task: Task!
    private var indexPath: IndexPath!
    
    private var animator: UIViewPropertyAnimator?
    private let gesture = RightToLeftSwipeGestureRecognizer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellUI()
        configureDeleteButton()
        configureUI()
        addGestureHandler()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureCellUI() {
        let shadowColor = Colors.black.cgColor
        cellView.backgroundColor = Colors.white
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = shadowColor
        cellView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.12
        cellView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureDeleteButton() {
        taskDeleteButton.alpha = 0
        taskDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        taskDeleteButton.image = UIImage(systemName: "trash.fill")
        taskDeleteButton.tintColor = .systemRed
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteTask))
        taskDeleteButton.addGestureRecognizer(gestureRecognizer)
        taskDeleteButton.isUserInteractionEnabled = true
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 15
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(cellView, taskDeleteButton)
        cellView.addSubviews(checkBoxButton, bodyLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            checkBoxButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            checkBoxButton.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: padding),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -padding),
            
            taskDeleteButton.heightAnchor.constraint(equalToConstant: 20),
            taskDeleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskDeleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    
    private func addGestureHandler() {
        self.addGestureRecognizer(self.gesture)
        self.gesture.addTarget(self, action: #selector(self.handleSwipeGesture(_:)))
    }
    
    
    func setCell(task: Task, indexPath: IndexPath) {
        self.task = task
        self.indexPath = indexPath
        
        setCellData()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        checkBoxButton.addGestureRecognizer(gestureRecognizer)
        checkBoxButton.isUserInteractionEnabled = true
    }
    
    
    private func setCellData() {
        if task.isDone {
            checkBoxButton.image = UIImage(systemName: "checkmark.circle.fill")
            addStrikethrough()
        } else {
            checkBoxButton.image = UIImage(systemName: "circle")
            removeStrikethrough()
        }
    }
    
    
    private func addStrikethrough() {
        let attributedText = NSAttributedString(
            string: self.task.title! as String,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        bodyLabel.attributedText = attributedText
    }
    
    
    private func removeStrikethrough() {
        let attributedText = NSAttributedString(string: self.task.title!)
        bodyLabel.attributedText = attributedText
    }
    
    
    @objc func toggleCheckBox() {
        self.task.isDone = !self.task.isDone
        
        delegate?.onToggleIsDone(task: task)
        setCellData()
    }
    
    
    @objc private func deleteTask() {
        delegate.onTapDeleteTask(indexPath: indexPath)
        transformToIdentity()
    }
    
    
    @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: self).x
        let threshold:CGFloat = -50
        
        switch gesture.state {
        
        case .changed:
            cellView.transform = CGAffineTransform(translationX: translationX + prevTranslateX, y: 0)
            
            if translationX > 0 {
                taskDeleteButton.alpha = (30 - translationX) / 50
            } else {
                taskDeleteButton.alpha = -translationX / 50
            }
        
        case .cancelled, .ended:
            guard translationX > threshold else {
                self.prevTranslateX = -50
                taskDeleteButton.alpha = 1
                transformToDeletePosition()
                return
            }
            
            taskDeleteButton.alpha = 0
            transformToIdentity()
        default:
            break
        }
    }
    
    
    private func transformToIdentity() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.cellView.transform = .identity
                self.prevTranslateX = 0
            }
        }
    }
    
    
    private func transformToDeletePosition() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.cellView.transform = CGAffineTransform(translationX: -50, y: 0)
            }
        }
    }
}
