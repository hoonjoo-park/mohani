//
//  ProgressVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit

protocol ProgressVCDelegate: AnyObject {
    func onChangeTask(tasks: [Task])
}

class ProgressVC: UIViewController {
    
    var tasks: [Task]!
    var totalTaskCount: Int!
    var doneTaskCount: Int!
    
    let titleLabel = TitleLabel(color: Colors.black)
    let progressLabel = TitleLabel(color: Colors.gray)
    let progressBar = UIView()
    let coloredProgressBar = UIView()
    
    
    init(title: String, tasks: [Task]) {
        super.init(nibName: nil, bundle: nil)
        
        self.tasks = tasks
        titleLabel.text = title
        
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
        configureProgressBar()
        configureColoredProgressBar()
        configureUI()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
    }
    
    
    func configureProgressBar() {
        progressBar.layer.cornerRadius = 10
        progressBar.backgroundColor = Colors.blueWhite
        progressBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureColoredProgressBar() {
        coloredProgressBar.layer.cornerRadius = 10
        coloredProgressBar.backgroundColor = Colors.blue
        coloredProgressBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureUI() {
        let padding:CGFloat = 20
        let multiplier:CGFloat = totalTaskCount == 0 ? 0 : CGFloat(doneTaskCount/totalTaskCount)
        
        view.addSubviews(titleLabel, progressLabel, progressBar, coloredProgressBar)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            progressBar.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 15),
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            progressBar.heightAnchor.constraint(equalToConstant: 15),

            coloredProgressBar.topAnchor.constraint(equalTo: progressBar.topAnchor),
            coloredProgressBar.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            coloredProgressBar.heightAnchor.constraint(equalToConstant: 15),
            coloredProgressBar.widthAnchor.constraint(equalTo: progressBar.widthAnchor, multiplier: multiplier)
        ])
    }
}
