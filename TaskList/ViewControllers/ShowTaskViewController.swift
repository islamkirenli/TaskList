//
//  ShowTaskViewController.swift
//  TaskList
//
//  Created by islam kirenli on 16.07.2024.
//

import UIKit

class ShowTaskViewController: UIViewController {
    
    @IBOutlet weak var taskLabel: UILabel!
    
    var receivedTaskName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLabel.text = receivedTaskName

    }

}
