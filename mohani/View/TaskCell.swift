//
//  TaskCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class TaskCell: UICollectionViewCell {
    static let reuseId = "TaskCell"
    
    var checkBoxButton = UIButton()
    let bodyLabel = BodyLabel(color: Colors.black)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellUI()
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(task: Task) {
        if task.isDone {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        } else {
            checkBoxButton.setImage(UIImage(systemName: "checkmark.circle.fillcirclebadge"), for: .normal)
        }
        
        bodyLabel.text = task.title
        return
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
            bodyLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 18),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }

}
