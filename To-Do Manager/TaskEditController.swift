//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 22.04.2022.
//

import UIKit

class TaskEditController: UITableViewController {
    
    //параметры задачи
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    
    private var taskTitles: [TaskPriority: String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    //Передача данных с помощью замыкания
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    
    //MARK: - Элементы на сцене
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    @IBOutlet var taskStatusSwitch: UISwitch!
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTitle.text = taskText
        
        //обвновление метки в соответствии текущим типом
        taskTypeLabel.text = taskTitles[taskType]
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    //двухсторонняя передача данных от TaskEditController к TaskTypeController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            //ссылка на контроллер назначения
            let destination = segue.destination as! TaskTypeController
            //передача выбранного типа
            destination.selectedType = taskType
            //передача обработчика выбора типа
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
            //обновляем метку с текущим типом
                taskTypeLabel.text = taskTitles[taskType]
            }
        }
    }
    //Передача актуальной задачи
    @IBAction func saveTask (_ sender: UIBarButtonItem) {
        //получаем актуальные значения
        //проверка не пустая ли строка
        //если пустая вывести ошибку
        guard taskTitle.text != "" else {
            alertConnection(
                header: "Внимание",
                titleInMessage: "Введите текст",
                style: .alert)
            return
        }
        let title = taskTitle.text
        let type = taskType
        let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
        //вызываем обработчик
        doAfterEdit?(title!, type, status)
        //возвращаемся к прошлому экрану
        navigationController?.popViewController(animated: true)
    }
    //алерт для TextField
    func alertConnection (header: String, titleInMessage: String, style: UIAlertController.Style ) {
    let alert1 = UIAlertController(title: header, message: titleInMessage, preferredStyle: style)
    let actionForAlert = UIAlertAction(title: "Ок", style: .cancel, handler: nil)
        
    alert1.addAction(actionForAlert)
    self.present(alert1, animated: true, completion: nil)
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
