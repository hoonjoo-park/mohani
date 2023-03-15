//
//  ProgressVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/30.
//

import UIKit
import RxSwift
import RxCocoa

class ProgressVC: UIViewController {
    private let disposeBag = DisposeBag()
    var taskVM: TaskViewModel!
    var currentDate: String!
    
    let titleLabel = TitleLabel(color: Colors.black)
    let progressLabel = TitleLabel(color: Colors.gray)
    let progressBar = TaskProgressView(frame: .zero)
    
    
    init(currentDate: String) {
        super.init(nibName: nil, bundle: nil)
        
        taskVM = TaskViewModel(createdAt: currentDate)
        titleLabel.text = currentDate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureUI()
        
        taskVM.tasks
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] tasks in
                let totalTaskCount = tasks.count
                let doneTaskCount = (tasks.filter { $0.isDone == true }).count
                
                self.configureProgressLabel(totalTaskCount, doneTaskCount)
                self.setProgressValue(totalTaskCount, doneTaskCount)
            }).disposed(by: disposeBag)
        
    }
    
    
    func configureViewController() {
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = 10
        
        view.addSubviews(titleLabel, progressLabel, progressBar)
    }
    
    
    func configureUI() {
        let padding:CGFloat = 20
        
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
    
    
    private func configureProgressLabel(_ totalTaskCount: Int, _ doneTaskCount: Int) {
        progressLabel.text = "\(doneTaskCount)/\(totalTaskCount)"
    }
    
    
    func setProgressValue(_ totalTaskCount: Int, _ doneTaskCount: Int) {
        let percentage:Float = doneTaskCount == 0 ? 0 : Float(Double(doneTaskCount) / Double(totalTaskCount))
        
        progressBar.setProgress(percentage, animated: true)
    }
}
