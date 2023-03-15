//
//  TaskViewModel.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import RxSwift


class TaskViewModel {
    private let repository = TaskCoreDataRepository()
    private let disposeBag = DisposeBag()
    private let createdAt: String!
    
    let tasks = BehaviorSubject<[Task]>(value: [])
    
    init(createdAt: String) {
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
    
    
    func addTask(title: String, createdAt: String) {
        repository.addTask(title: title, createdAt: createdAt).subscribe(
            onCompleted: { [unowned self] in
                do {
                    var currentTasks = try tasks.value()
                    
                    let newTask = Task()
                    newTask.title = title
                    newTask.createdAt = createdAt
                    newTask.isDone = false
                    
                    currentTasks.append(newTask)
                    self.tasks.onNext(currentTasks)
                } catch {
                    fatalError("error: \(error)")
                }
            }) { error in
                fatalError("error: \(error)")
            }.disposed(by: disposeBag)
    }
    
    
    func deleteTask(_ task:Task) {
        repository.deleteTask(task).subscribe(
            onCompleted: { [unowned self] in
                do {
                    let currentTasks = try tasks.value()
                    let filteredTasks = currentTasks.filter { currentTask in
                        return currentTask != task
                    }
                    tasks.onNext(filteredTasks)
                } catch {
                    fatalError("error: \(error)")
                }
            }) { error in
                fatalError("error: \(error)")
            }.disposed(by: disposeBag)
    }
}
