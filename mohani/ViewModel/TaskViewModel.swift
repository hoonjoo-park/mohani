//
//  TaskViewModel.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import RxSwift
import RxCocoa


class TaskViewModel {
    private let repository = TaskCoreDataRepository()
    private let disposeBag = DisposeBag()
    private let createdAt: String!
    
    let tasks = BehaviorRelay<[Task]>(value: [])
    let errorRelay = PublishRelay<Error>()
    
    init(createdAt: String) {
        self.createdAt = createdAt
        fetchTasks(createdAt)
    }
    
    
    func fetchTasks(_ createdAt: String) {
        repository.fetchTasks(createdAt: createdAt).subscribe(
            onSuccess: { [unowned self] tasks in
                self.tasks.accept(tasks)
            },
            onFailure: { [unowned self] error in
                self.errorRelay.accept(error)
            }
        ).disposed(by: disposeBag)
    }
    
    
    func addTask(title: String, createdAt: String) {
        let newTask = Task()
        newTask.title = title
        newTask.createdAt = createdAt
        newTask.isDone = false
        
        repository.addTask(newTask)
            .subscribe(
                onCompleted: { [unowned self] in
                    var currentTasks = self.tasks.value
                    currentTasks.append(newTask)
                    self.tasks.accept(currentTasks)
                },
                onError: { [unowned self] error in
                    self.errorRelay.accept(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
    func deleteTask(_ task:Task) {
        repository.deleteTask(task).subscribe(
            onCompleted: { [unowned self] in
                let currentTasks = tasks.value
                let filteredTasks = currentTasks.filter { currentTask in
                    return currentTask != task
                }
                tasks.accept(filteredTasks)
            }) { [unowned self] error in
                self.errorRelay.accept(error)
            }.disposed(by: disposeBag)
    }
    
    
    func toggleIsDone(_ task: Task) {
        task.isDone.toggle()
        
        do {
            try repository.context.save()
        } catch {
            errorRelay.accept(error)
        }

        let updatedTasks = tasks.value.sorted { return !$0.isDone && $1.isDone }
        tasks.accept(updatedTasks)
    }
}
