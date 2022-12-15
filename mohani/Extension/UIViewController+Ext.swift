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
    
    func fetchTasks(date: String) -> [Task] {
        let fetchTasksRequest = Task.fetchRequest() as NSFetchRequest<Task>
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
        let fetchTodoListRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchTodoListRequest.predicate = predicate
        
        do {
            let todo = try context.fetch(fetchTodoListRequest)
            
            guard todo.count > 0 else {
                let newTodoInfo = TodoList(context: context)
                newTodoInfo.createdAt = date
                
                saveContext()
                
                return [newTodoInfo]
            }
            
            return todo
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
            return []
        }
    }
    
    
    func fetchAllTodoList() -> [TodoList] {
        let fetchTodoListRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
        
        do {
            let todoList = try context.fetch(fetchTodoListRequest)
            
            guard todoList.count > 0 else { return [] }
            
            return todoList
        }
        catch {
            return []
        }
    }
    
    
    func addTask(title: String, createdAt: String) {
        let newTask = Task(context: context)
        newTask.title = title
        newTask.createdAt = createdAt
        newTask.isDone = false
        
        saveContext()
    }
    
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            // TODO: 에러 핸들링 로직 필요
        }
    }
    
    func showToastMessage(message: String, status: ToastStatus) {
        let padding: CGFloat = 20
        let frame = CGRect(x: padding, y: UIScreen.main.bounds.height / 2 + 26, width: UIScreen.main.bounds.width - 2 * padding, height: 52)
        let toastMessageView = ToastMessageView(frame: frame, message: message, status: status)
        
        DispatchQueue.main.async {
            self.view.addSubview(toastMessageView)
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                toastMessageView.frame = CGRect(x: padding, y: UIScreen.main.bounds.height / 2 - 52, width: UIScreen.main.bounds.width - 2 * padding, height: 52)
                return
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            toastMessageView.removeFromSuperview()
        }
    }
}
