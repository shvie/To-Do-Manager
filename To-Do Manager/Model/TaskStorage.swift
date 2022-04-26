//
//  TaskStorage.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 19.04.2022.
//
import Foundation

//Протокол описывающий сущность "Хранилизе задач"
protocol TaskStorageProtocol {
    func loadTask() -> [TaskProtocol]
    func saveTask(_ tasks: [TaskProtocol])
}

//Сущность "Хранилище задач"
class TaskStorage: TaskStorageProtocol{
    
    //Cсылка на хранилище
    private var storage = UserDefaults.standard
    //Ключ по которому будет происходить сохранение и загрузка хранилища в User Defaults
    var strorageKey: String = "tasks"
    
    //Перечисление с ключами для записи в User Defaults
    private enum TaskKey: String {
        case title
        case type
        case status
    }
    
    func loadTask() -> [TaskProtocol] {
        var resultTasks: [TaskProtocol] = []
        let tasksFromStorage = storage.array(forKey: strorageKey) as? [[String:String]] ?? []
        for task in tasksFromStorage {
            guard let title = task[TaskKey.title.rawValue],
                  let typeRaw = task[TaskKey.type.rawValue],
                  let statusRaw = task[TaskKey.status.rawValue]
            else {
            continue
        }
            let type: TaskPriority = typeRaw == "important" ? .important : .normal
            let status: TaskStatus = statusRaw == "planned" ? .planned : .completed
            resultTasks.append(Task(title: title, type: type, status: status))
        }
        return resultTasks
    }
    
    func saveTask(_ tasks: [TaskProtocol]) {
        var arrayForStorage: [[String:String]] = []
        tasks.forEach { task in
            var newElementForStorage: Dictionary <String, String> = [:]
            newElementForStorage[TaskKey.title.rawValue] = task.title
            newElementForStorage[TaskKey.type.rawValue] = (task.type == .important) ? "important" : "normal"
            newElementForStorage[TaskKey.status.rawValue] = (task.status == .planned) ? "planned" : "completed"
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: strorageKey)
    }
}



