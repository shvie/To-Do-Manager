//
//  TaskTypeController.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 22.04.2022.
//

import UIKit

class TaskTypeController: UITableViewController {
    
    //1. Кортеж описывающий тип задачи
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    
    //2. коллекция доступных типов задач с их описанием
    private var taskTypesInformation: [TypeCellDescription] = [
        (type: .important, title: "Важная", description: "Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи выводятся верху списка задач"), (type: .normal, title: "Текущая", description: "Задача с обычным приоритетом")]
    
    //3. выбранный приоритет
    var selectedType: TaskPriority = .normal
    
    //Обработчик выбора типа
    var doAfterTypeSelected: ((TaskPriority) -> Void)?
    
    //MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        //1. Получение значения типа UINib, соответсвующее xib-файлу кастомной ячейки
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        // Регистрация кастомной ячейки в табличном представлении
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskTypesInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1. Получение переиспользуемой кастомной ячейки по ее индентификатору
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        //2. Получаем текущий элемент информация о котором должна выведена в строке
        let typeDescription = taskTypesInformation[indexPath.row]
        //3. Заполняем ячейку данными
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        //4. Если тип является выбранным, то отмечаем галочкой
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
            //в ином случае снимаем отметку
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Получаем выбранный тип
        let selectedType = taskTypesInformation[indexPath.row].type
        //вызов обработчика
        doAfterTypeSelected?(selectedType)
        //переход к предыдущему экрану
        navigationController?.popViewController(animated: true)
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
