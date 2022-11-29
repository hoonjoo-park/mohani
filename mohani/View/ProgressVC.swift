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
    
    let titleLabel = UILabel()
    let progressLabel = UILabel()
    let progressBar = UIView()
    let coloredProgressBar = UIView()
    
    
    init(tasks: [Task]) {
        super.init(nibName: nil, bundle: nil)
        self.tasks = tasks
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
    }
    
    
    func configureUI() {
        view.addSubviews(titleLabel, progressLabel, progressBar, coloredProgressBar)
    }
}
