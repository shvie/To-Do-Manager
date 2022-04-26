//
//  Task.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 19.04.2022.
//

//Тип задачи
enum TaskPriority {
    //текущая
    case normal
    //важаная
    case important
    
}
//Состояние задачи
//Первый элемент перечисления имеет связанное с ним целочисленное значение 0, второй – 1. Именно по этим значениям будет определяться порядок задач на сцене.
enum TaskStatus: Int {
    //Запланированная
    case planned
    //завершенная
    case completed
}

//Требование к типу описывающему сущность "Задача"
protocol TaskProtocol {
    //название
    var title: String { get set }
    //тип
    var type: TaskPriority { get set }
    //статус
    var status: TaskStatus { get set }
}

//сущность "Задача"
struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}
