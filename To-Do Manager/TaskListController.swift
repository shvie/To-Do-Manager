//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 19.04.2022.
//

import UIKit

class TaskListController: UITableViewController {
    
    //хранилище задач
    var tasksStorage: TaskStorageProtocol = TaskStorage()
    //коллекция задач (словарь)
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
            
            var savingArray: [TaskProtocol] = []
            tasks.forEach { _, value in
                savingArray += value
            }
            tasksStorage.saveTask(savingArray)
            
            //сортировка задач
            for (tasksGroupPriority, tasksGroup) in tasks {
                tasks[tasksGroupPriority] = tasksGroup.sorted{ task1, task2 in
                    let task1Position = tasksStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2Position = tasksStatusPosition.firstIndex(of: task2.status) ?? 0
                    return task1Position < task2Position
                }
            }
        }
    }
    //порядок отображения сеций по типам
    //индекс в массиве соответсвует индексу секции в таблице
    var sectionsTypePosition: [TaskPriority] = [.important, .normal]
    //порядок отображения по их статусу
    var tasksStatusPosition: [TaskStatus] = [.planned, .completed]
    
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        //загрузка задач
        //loadTasks()
        //кнопка активации режима редактирования
        navigationItem.leftBarButtonItem = editButtonItem
    }
    //MARK: - Methods
    
    private func loadTasks(){
        //подкготовка коллекции с задачами
        //будем использовать только те задачи для которых определена секция в таблице
        sectionsTypePosition.forEach{ taskType in
            tasks[taskType] = []
        }
        //загрузка и разбор задач из хранилища
        tasksStorage.loadTask().forEach{ task in
            tasks[task.type]?.append(task)}
   }
    
    func setTasks (_ tasksCollection: [TaskProtocol]) {
        //подготовка коллекции с задачами
        //будем использовать только те задачи  для которых определена секция
        sectionsTypePosition.forEach { taskType in
            tasks[taskType] = []
        }
        //загрузка и разбор задач
        tasksCollection.forEach { task in
            tasks[task.type]?.append(task)
        }
    }
    
    
    // MARK: - Table view data source

    //количесво секций в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }
    
    //количество строк в определенной секции секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //определяем приоритет задач соответсвующей секции
        let taskType = sectionsTypePosition[section]
        guard let currentTasksType = tasks[taskType] else {
            return 0
        }
        return currentTasksType.count
    }
    
    //ячейка для строки таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //ячейки на освнове констрейнтов
        //return getConfiguratedTaskCell_constraints(for: indexPath)
        
        //ячейки на освнове стека
        return getConfiguratedCell_stack(for: indexPath)
    }
    
    //ручная сортировка списка задач
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //секция из которой происходит перемещение
        let taskTypeFrom = sectionsTypePosition[sourceIndexPath.section]
        //секция в которую происходит перемещение
        let taskTypeTo = sectionsTypePosition[destinationIndexPath.section]
        
        //безопасно извлекаем задачу тем самым копируя ее
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        
        //удаляем задачу с места откуда она была перенесена
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        //вставляем на новую позицию
        tasks[taskTypeTo]?.insert(movedTask, at: destinationIndexPath.row)
        //если секция изменилась изменяем тип задачи в соответсвии с новой позицией
        if taskTypeFrom != taskTypeTo {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        //обновляем данные
        tableView.reloadData()
    }
    
    //Удаление задачи
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionsTypePosition[indexPath.section]
        //удаляем задачу
        tasks[taskType]?.remove(at: indexPath.row)
        //удаляем строку, соответствующую задаче
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //MARK: - Ячейка на основе ограничений
    private func getConfiguratedTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell{
        //загружаем прототип ячекий по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        //получаем данные о задаче которую необходимо вывести в ячейке
        let taskType = sectionsTypePosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        //текстовая метка символа
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        //текстовая метка задачи
        let textLabel = cell.viewWithTag(2) as? UILabel
        
        //изменяем символ в ячейки
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        //изменяем текст в ячейке
        textLabel?.text = currentTask.title
        
        //изменяем цвет текста и символа
        if currentTask.status == .planned {
            textLabel?.textColor = .black
            symbolLabel?.textColor = .black
        } else {
            textLabel?.textColor = .lightGray
            symbolLabel?.textColor = .lightGray
        }
        return cell
    }
    //возвращаем символ для соответствубщего типа задачи
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        return resultSymbol
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let tasksType = sectionsTypePosition[section]
        if tasksType == .important {
            title = "Важные"
        } else if tasksType == .normal {
            title = "Текущие"
        }
        return title
    }
    //получение новой задачи и вывод ее в список 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateScreen" {
            let destination = segue.destination as! TaskEditController
            destination.doAfterEdit = { [unowned self] title, type, status in
                let newTask = Task(title: title, type: type, status: status)
                tasks[type]?.append(newTask)
                tableView.reloadData()
            }
        }
    }
    //MARK: - Ячейка на основе стека
    private func getConfiguratedCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        //загружаем прототип ячейки по идентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        //получаем данные о задаче которые необходимо вывести в ячейке
        let taskType = sectionsTypePosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        
        //изменяем текст в ячейке
        cell.title.text = currentTask.title
        //изменяем сивол в ячейке
        cell.syblol.text = getSymbolForTask(with: currentTask.status)
        
        //изменяем цвет текста и символа
        if currentTask.status == .planned {
            cell.title.textColor = .black
            cell.syblol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.syblol.textColor = .lightGray
        }
        return cell
    }
    //MARK: - Изменение статуса задачи на "выполнено"
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1. Проверяем существование задачи
        let taskType = sectionsTypePosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        //2.Убеждаемся что задача является выполненной
        guard tasks [taskType]![indexPath.row].status == .planned
        else {
            //снимаем выделение со строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        //3.Отмечаем задачу как выполненную
        tasks[taskType]![indexPath.row].status = .completed
        //4.Перезагружаем секцию таблицы
        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    //MARK: - Изменение статуса задачи на "Запланирована"
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Получаем данные о задаче которую необходимо перевести в статус "запланирована"
        let taskType = sectionsTypePosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row]
        else {
            return nil
        }
        //создаем действие для статуса
        let actrionSwipeInstance = UIContextualAction(
            style: .normal,
            title: "Не выполнена") {_,_,_ in
                self.tasks[taskType]![indexPath.row].status = .planned
                self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section),with: .automatic)
            }
        //действие для перехода к экрану редактирования
        let actionEditInstance = UIContextualAction(
            style: .normal,
            title: "Изменить") {_,_,_ in
                //загрузка сцены со сториборд
                let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskEditController") as! TaskEditController
                //передача значений редактируемой задачи
                editScreen.taskText = self.tasks[taskType]![indexPath.row].title
                editScreen.taskType = self.tasks[taskType]![indexPath.row].type
                editScreen.taskStatus = self.tasks[taskType]![indexPath.row].status
                //передача обработчика для сохранения задачи
                editScreen.doAfterEdit = { [self] title, type, status in
                    let editedTask = Task(title: title, type: type, status: status)
                    tasks[taskType]![indexPath.row] = editedTask
                    tableView.reloadData()
                }
                //переход к сцене редактирования
                self.navigationController?.pushViewController(editScreen, animated: true)
            }
        //изменяем цвет фона кнопки с действием
        actionEditInstance.backgroundColor = .darkGray
        
        //создаем эффект описывающий действия
        //в зависимости от статуса задачи будет отображено 1 или 2 действия
        let actionsConfiguration: UISwipeActionsConfiguration
        if tasks[taskType]![indexPath.row].status == .completed {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actrionSwipeInstance, actionEditInstance])
        } else {
            actionsConfiguration = UISwipeActionsConfiguration(actions: [actionEditInstance])
        }
        //возвращаем настроенный обьект
        return actionsConfiguration
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
