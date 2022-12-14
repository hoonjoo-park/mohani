//
//  TodoListCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/14.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    static let reuseID = "TodoListCell"
    
    let listLabel = TitleLabel(color: Colors.white)

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        configureListLabel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(todoList: TodoList) { listLabel.text = todoList.createdAt }
    
    
    private func configureUI() {
        addSubview(listLabel)
        accessoryType = .disclosureIndicator
        backgroundColor = Colors.gray
    }
    
    
    private func configureListLabel() {
        NSLayoutConstraint.activate([
            listLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            listLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            listLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
