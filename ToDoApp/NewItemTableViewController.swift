//
//  NewItemTableViewController.swift
//  ToDoApp
//
//  Created by Maks on 04.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class NewItemTableViewController: UITableViewController {

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var prioritySwitch: UISwitch!
 
    var object = List(tittle: "", isPriority: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        updateUI()

    }

    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        updateSaveButton()
    }
    
    
    private func updateSaveButton() {
        let taskText = taskTextField.text ?? ""
        saveButton.isEnabled = !taskText.isEmpty
    }
    
    private func updateUI(){
        taskTextField.text = object.tittle
        prioritySwitch.isOn = object.isPriority
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        let task = taskTextField.text ?? ""
        let isPriority = prioritySwitch.isOn
        self.object = List(tittle: task, isPriority: isPriority)
        
    }
    
    
    //    Hide the keyboard and checking fills of all fields
//      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//          view.endEditing(true)
//          if taskTextField.text?.isEmpty == false {
//                      saveButton.isEnabled = true
//          }
//          else { saveButton.isEnabled = false }
//      }

  
}
