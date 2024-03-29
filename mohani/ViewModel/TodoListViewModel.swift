//
//  TodoListViewModel.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import RxSwift
import RxCocoa

class TodoListViewModel {
    private let repository = TodoListCoreDataRepository()
    private let createdAt: String!
    private let disposeBag = DisposeBag()
    
    let todoList = BehaviorSubject<[TodoList]>(value: [])
    let todoListInfo = BehaviorSubject<TodoList>(value: TodoList())
    let errorRelay = PublishRelay<Error>()
    
    init(createdAt: String!) {
        self.createdAt = createdAt
        
        fetchAllTodoList()
    }
    
    
    func fetchAllTodoList() {
        repository.fetchAllTodoList().subscribe(
            onSuccess: { [unowned self] todoLists in
                self.todoList.onNext(todoLists)
            },
            onFailure: { [unowned self] error in
                self.errorRelay.accept(error)
            }
        ).disposed(by: disposeBag)
    }
    
    
    func fetchTodoListInfo(_ createdAt: String) {
        repository.fetchTodoListInfo(createdAt: createdAt).subscribe(
            onSuccess: { [unowned self] todoList in
                self.todoListInfo.onNext(todoList[0])
            },
            onFailure: { [unowned self] error in
                self.errorRelay.accept(error)
            }
        ).disposed(by: disposeBag)
    }
    
    
    func removeTodoList(todoList: TodoList) {
        repository.removeTodoList(todoList: todoList).subscribe(
            onCompleted: { [unowned self] in
                do {
                    let currentTodoList = try self.todoList.value()
                    let filteredTodoList = currentTodoList.filter { return $0 != todoList }
                    self.todoList.onNext(filteredTodoList)
                } catch {
                    self.errorRelay.accept(error)
                }
            },
            onError: { [unowned self] error in
                self.errorRelay.accept(error)
            }
        ).disposed(by: disposeBag)
    }
}
