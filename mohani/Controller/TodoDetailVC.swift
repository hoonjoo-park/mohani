//
//  TodoDetailVC.swift
//  mohani
//
//  Created by Hoonjoo Park on 2022/11/29.
//

import UIKit
import CoreData

class TodoDetailVC: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoInfo: TodoList? = nil
    var tasks: [Task] = []
    var today = Date().toYearMonthDate()
    var isTodoNew = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = today
        navigationController?.navigationBar.prefersLargeTitles = true
        
        fetchTodoInfo(date: today)
        fetchTasks(date: today)
    }
    
    
    func fetchTodoInfo(date: String) {
        let fetchRequest = TodoList.fetchRequest() as NSFetchRequest<TodoList>
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchRequest.predicate = predicate
        
        do {
            let todo = try context.fetch(fetchRequest)

            guard todo.count > 0 else {
                let newTodoInfo = TodoList(context: context)
                newTodoInfo.createdAt = date

                self.todoInfo = newTodoInfo
                try self.context.save()
                return
            }

            todoInfo = todo[0]
            isTodoNew = false
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
        }
    }

    
    func fetchTasks(date: String) {
        guard !self.isTodoNew else { return }
        
        let fetchRequest = Task.fetchRequest() as NSFetchRequest<Task>
        let predicate = NSPredicate(format: "createdAt == %@", date)
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            guard tasks.count > 0 else { return }
            
            self.tasks = tasks
            // TODO: 테이블뷰 데이터 갱신
        }
        catch {
            // TODO: 에러 핸들링 로직 추가 필요
        }
    }
    
    
}

// 1. 해당 뷰컨트롤러에 필요한 View 정의하기
    // 스크롤뷰, ProgressInfoView, todoLabel,tableView, tableViewCell, addTaskButton
// 2. TodoInfo를 fetch하는 함수 작성
// 3. 있으면 ? -> createdAt을 title로 세팅, 그리고 그에 따른 fetchTasks 진행
// 4. 없으면 ? -> createdAt의 포멧을 "YYYY.MM.DD" 형식으로 변환하여 데이터 생성(Create)
// 5. fetchTasks 후 -> 데이터를 통해 뷰 그려주기
// 6. Task들이 들어갈 테이블 뷰 생성하기 (Delegate 및 DataSource 설정 포함)
// 7. 각 UIView의 레이아웃 잡기
