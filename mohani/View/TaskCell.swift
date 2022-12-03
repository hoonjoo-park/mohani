//
//  TaskCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class TaskCell: UICollectionViewCell {
    static let reuseId = "TaskCell"
    
    var checkBoxButton = UIImageView()
    let bodyLabel = BodyLabel(color: Colors.black)
    
    var isDone: Bool!
    var title: String!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellUI()
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(task: Task) {
        self.isDone = task.isDone
        self.title = task.title
        
        setCellByIsDone(isDone: task.isDone)
        
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        checkBoxButton.addGestureRecognizer(gestureRecognizer)
        checkBoxButton.isUserInteractionEnabled = true
        
        return
    }
    
    
    private func setCellByIsDone(isDone: Bool) {
        if isDone {
            checkBoxButton.image = UIImage(systemName: "checkmark.circle.fill")
            addStrikethrough()
        } else {
            checkBoxButton.image = UIImage(systemName: "circle")
            removeStrikethrough()
        }
    }
    
    
    private func addStrikethrough() {
        let attributedText = NSAttributedString(
            string: self.title as String,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        bodyLabel.attributedText = attributedText
    }
    
    
    private func removeStrikethrough() {
        let attributedText = NSAttributedString(string: self.title)
        bodyLabel.attributedText = attributedText
    }
    
    
    @objc func toggleCheckBox() {
        self.isDone = !isDone
        setCellByIsDone(isDone: self.isDone)
    }
    
    
    private func configureCellUI() {
        let shadowColor = Colors.black.cgColor
        self.backgroundColor = Colors.white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.12
        
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
}
