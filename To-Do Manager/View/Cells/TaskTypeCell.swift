//
//  TaskTypeCell.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 22.04.2022.
//

import UIKit

class TaskTypeCell: UITableViewCell {
    //элементы в ячеке
    @IBOutlet var typeTitle: UILabel!
    @IBOutlet var typeDescription: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
