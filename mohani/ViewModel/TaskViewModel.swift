//
//  TaskViewModel.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import RxSwift


class TaskViewModel {
    private let repository: TaskCoreDataRepository
    private let disposeBag = DisposeBag()
    private let createdAt: String!
    
    let tasks = BehaviorSubject<[Task]>(value: [])
    
    init(repository: TaskCoreDataRepository, createdAt: String) {
        self.repository = repository
        self.createdAt = createdAt
        
        fetchTasks(createdAt)
    }
    
    func fetchTasks(_ createdAt: String) {
        repository.fetchTasks(createdAt: createdAt).subscribe(
            onSuccess: { [unowned self] tasks in
                self.tasks.onNext(tasks)
            },
            onFailure: { error in fatalError("error: \(error)") }
        ).disposed(by: disposeBag)
    }
    
//    func createTask(title: String, createdAt: String) {
//        repository.createTask(title: title, createdAt: createdAt).subscribe(onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//    }
}
