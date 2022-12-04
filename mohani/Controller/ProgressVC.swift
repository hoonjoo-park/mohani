//
//  ProgressVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

class ProgressVC: UIViewController {
    
    var tasks: [Task]!
    var totalTaskCount: Int!
    var doneTaskCount: Int!
    
    let titleLabel = TitleLabel(color: Colors.black)
    let progressLabel = TitleLabel(color: Colors.gray)
    let progressBar = TaskProgressView(frame: .zero)
    
    
    init(title: String, tasks: [Task]) {
        super.init(nibName: nil, bundle: nil)
        
        self.tasks = tasks
        titleLabel.text = title
        
        configureProgressLabel(tasks: tasks)
    }
    
    
    private func configureProgressLabel(tasks: [Task]) {
        self.tasks = tasks
        
        totalTaskCount = tasks.count
        doneTaskCount = (tasks.filter { $0.isDone == true }).count
        progressLabel.text = "\(doneTaskCount ?? 0)/\(totalTaskCount ?? 0)"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUI()
        setProgressValue()
    }
    
    
    func configureViewController() {
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = 10
    }
    
    
    func setProgressValue() {
        let percentage:Float = Float(Double(doneTaskCount) / Double(totalTaskCount))
        
        progressBar.progress = percentage
    }
    
    
    func configureUI() {
        let padding:CGFloat = 20
        
        view.addSubviews(titleLabel, progressLabel, progressBar)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 15),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            progressBar.trailingAnchor.constraint(equalTo: progressLabel.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
}

extension ProgressVC: TodoDetailVCDelegate {
    
    func onChangeTask(tasks: [Task]) {
        DispatchQueue.main.async {
            self.configureProgressLabel(tasks: tasks)
            self.setProgressValue()
            return
        }
    }
}
