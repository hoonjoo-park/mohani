//
//  TodoListCoreDataRepository.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import CoreData
import RxSwift

protocol TodoListCoreDataRepositoryProtocol: AnyObject {
    func fetchTodoListInfo(createdAt: String) -> Single<[TodoList]>
    func fetchAllTodoList() -> Single<[TodoList]>
    func removeTodoList(todoList: TodoList) -> Completable
}

class TodoListCoreDataRepository: TodoListCoreDataRepositoryProtocol {
    var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    
    func fetchTodoListInfo(createdAt: String) -> RxSwift.Single<[TodoList]> {
        return Single.create { [unowned self] single in
            let fetchTodoListRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
            let predicate = NSPredicate(format: "createdAt == %@", createdAt)
            fetchTodoListRequest.predicate = predicate
            
            do {
                let todo = try context.fetch(fetchTodoListRequest)
                
                if todo.isEmpty {
                    createNewTodoList(createdAt).subscribe(onSuccess: { newTodoList in
                        single(.success([newTodoList]))
                    }, onFailure: { error in
                        single(.failure(error))
                    }).dispose()
                } else {
                    do {
                        try context.save()
                        single(.success(todo))
                    } catch {
                        single(.failure(error))
                    }
                }
            }
            catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    private func createNewTodoList(_ createdAt: String) -> Single<TodoList> {
        return Single.create { [unowned self] single in
            let newTodoInfo = TodoList(context: context)
            newTodoInfo.createdAt = createdAt
            
            do {
                try context.save()
                single(.success(newTodoInfo))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    func fetchAllTodoList() -> RxSwift.Single<[TodoList]> {
        return Single.create { [unowned self] single in
            let fetchTodoListRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
            
            do {
                let todoList = try context.fetch(fetchTodoListRequest)
                single(.success(todoList))
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    func removeTodoList(todoList: TodoList) -> Completable {
        return Completable.create { [unowned self] completable in
            let createdAt = todoList.createdAt!
            let fetchTaskRequest = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format: "createdAt == %@", createdAt)
            fetchTaskRequest.predicate = predicate
            
            do {
                let tasksToDelete = try context.fetch(fetchTaskRequest)
                
                for task in tasksToDelete {
                    context.delete(task)
                }
                
                context.delete(todoList)
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
