//
//  TaskCell.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class TaskCell: UITableViewCell {
    static let reuseId = "TaskCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCell(task: Task) {
        // TODO: task를 넘겨 받은 뒤 -> title과 isDone에 대한 처리를 수행
        return
    }

}
