//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by Maks on 03.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var objects = [
        [
            List(tittle: "Swipe left to delete", isPriority: true),
            List(tittle: "Swipe right to mark done", isPriority: true),
            List(tittle: "Tap to edit", isPriority: true)
        ],
        [
            List(tittle: "Create application", isPriority: false, isDone: true),
            List(tittle: "Build a house", isPriority: false),
            List(tittle: "Plant a tree", isPriority: false)
        ]
    ]
    
    let sectionNames = ["Priority Tasks", "Secondary Tasks"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tableView.tableFooterView = UIView() // убираем нижние ячейки
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editTask" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let object = objects[indexPath.section] [indexPath.row]
        let navigationVC = segue.destination as! UINavigationController
        let newTaskVC = navigationVC.topViewController as! NewItemTableViewController
        newTaskVC.object = object
        newTaskVC.title = "Edit"
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveSegue" else { return }
        let sourceViewController = segue.source as! NewItemTableViewController
        let object = sourceViewController.object
        
        // Изменить существующий или добавить новый объект
        let sectionNumb = object.isPriority == true ? 0: 1
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.section].remove(at: selectedIndexPath.row)
            objects[sectionNumb].insert(object, at: 0)
            tableView.reloadData()
            
        } else {
            objects[sectionNumb].insert(object, at: 0)
            tableView.reloadData()
        }

        
        // Use data from the view controller which initiated the unwind segue
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = objects[indexPath.section][indexPath.row].tittle
        cell.textLabel?.alpha = 1
        
        if objects[indexPath.section][indexPath.row].isDone == true {
            cell.imageView?.image = .checkmark
            cell.textLabel?.alpha = 0.5
        }
        else {
            cell.imageView?.image = UIImage(systemName: "circle")
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedData = objects[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        objects[destinationIndexPath.section].insert(movedData, at: destinationIndexPath.row)
        let priorityValue = destinationIndexPath.section == 0 ? true : false
        objects[destinationIndexPath.section][destinationIndexPath.row].isPriority = priorityValue
        tableView.reloadData()
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.objects[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            self.objects[indexPath.section][indexPath.row].isDone = !self.objects[indexPath.section][indexPath.row].isDone
            self.tableView.reloadRows(at: [indexPath], with: .fade)
            completion(true)
        }
        action.backgroundColor = UIColor.blue
        return action
    }
    
    
}
