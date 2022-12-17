//
//  TaskCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func onToggleIsDone(task: Task)
}

class TaskCell: UICollectionViewCell {
    static let reuseId = "TaskCell"
    
    var checkBoxButton = UIImageView()
    var delegate: TaskCellDelegate!
    let bodyLabel = BodyLabel(color: Colors.black)
    
    var task: Task!
    
    private var animator: UIViewPropertyAnimator?
    private let gesture = RightToLeftSwipeGestureRecognizer()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellUI()
        configureUI()
        addGestureHandler()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(task: Task) {
        self.task = task
        
        setCellData()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        checkBoxButton.addGestureRecognizer(gestureRecognizer)
        checkBoxButton.isUserInteractionEnabled = true
        
        return
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
    
    
    private func configureCellUI() {
        let shadowColor = Colors.black.cgColor
        self.backgroundColor = Colors.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.12
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(checkBoxButton, bodyLabel)
    }
    
    
    private func configureUI() {
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            checkBoxButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBoxButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
    
    private func addGestureHandler() {
        self.addGestureRecognizer(self.gesture)
        self.gesture.addTarget(self, action: #selector(self.handleSwipeGesture(_:)))
    }
    
    @objc private func handleSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: self).x
        let threshold:CGFloat = -50
        
        switch gesture.state {
        case .changed:
            self.transform = CGAffineTransform(translationX: translationX, y: 0)
        case .cancelled, .ended:
            guard translationX > threshold else { return }
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.transform = .identity
            }
        default:
            break
        }
    }
}
