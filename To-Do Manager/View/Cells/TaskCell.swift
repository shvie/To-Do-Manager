//
//  TaskCell.swift
//  To-Do Manager
//
//  Created by Vitaliy Shmelev on 19.04.2022.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var syblol: UILabel!
    @IBOutlet var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
