//
//  UIViewController+Ext.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/12/01.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext { return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext }
    var fetchTodoListRequest: NSFetchRequest<TodoList> { return TodoList.fetchRequest() }
    var fetchTasksRequest: NSFetchRequest<Task> { return Task.fetchRequest() }
    
    func fetchTasks(date: String) -> [Task] {
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchTasksRequest.predicate = predicate
        
        do {
            let tasks = try context.fetch(fetchTasksRequest)
            
            guard tasks.count > 0 else { return [] }
            
            return tasks
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
            return []
        }
    }
    
    
    func fetchTodoListInfo(date: String) -> [TodoList] {
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchTodoListRequest.predicate = predicate
        
        do {
            let todo = try context.fetch(fetchTodoListRequest)

            guard todo.count > 0 else {
                let newTodoInfo = TodoList(context: context)
                newTodoInfo.createdAt = date

                try context.save()
                
                return [newTodoInfo]
            }
            
            return todo
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
            return []
        }
    }
    
    
    func addTask(title: String, createdAt: String) {
        let newTask = Task(context: context)
        newTask.title = title
        newTask.createdAt = createdAt
        newTask.isDone = false
        
        do {
            try context.save()
        }
        catch {
            // TODO: 에러 핸들링 로직 필요
        }
    }
}
