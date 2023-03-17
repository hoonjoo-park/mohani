//
//  TaskCoreDataRepository.swift
//  mohani
//
//  Created by Hoonjoo Park on 2023/03/15.
//

import Foundation
import CoreData
import RxSwift

protocol TaskCoreDataRepositoryProtocol: AnyObject {
    func addTask(_ title: String, _ createdAt: String) -> Single<Task>
    func fetchTasks(createdAt: String) -> Single<[Task]>
    func deleteTask(_ task: Task) -> Completable
}

class TaskCoreDataRepository: TaskCoreDataRepositoryProtocol {
    var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    
    func fetchTasks(createdAt: String) -> RxSwift.Single<[Task]> {
        return Single.create { [unowned self] single in
            let fetchTasksRequest = Task.fetchRequest() as NSFetchRequest<Task>
            let predicate = NSPredicate(format: "createdAt == %@", createdAt)
            fetchTasksRequest.predicate = predicate
            
            do {
                let tasks = try context.fetch(fetchTasksRequest)
                single(.success(tasks))
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    
    func addTask(_ title: String, _ createdAt: String) -> Single<Task> {
        return Single.create { [unowned self] single in
            let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context) as! Task
            task.title = title
            task.createdAt = createdAt
            task.isDone = false
            
            do {
                try self.context.save()
                single(.success(task))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    func deleteTask(_ task: Task) -> Completable {
        return Completable.create { [unowned self] completable in
            context.delete(task)
            
            do {
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
