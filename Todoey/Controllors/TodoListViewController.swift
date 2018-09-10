//
//  ViewController.swift
//  Todoey
//
//  Created by user137691 on 9/5/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    let defaults=UserDefaults.standard
    var itemsArray=[Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let item=Item()
        item.title="work"
        itemsArray.append(item)
        
        /*    if let array=defaults.array(forKey: "todoArray") as? [Item]{
         itemsArray=array
         }*/
        if let decoded  = UserDefaults.standard.object(forKey: "todoArray2") as? Data{
          let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Item]
            itemsArray=decodedTeams
        }
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row].title
        itemsArray[indexPath.row].checked==true ? (cell.accessoryType = .checkmark): (cell.accessoryType = .none)
        return cell
    }
    //MARK: - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("you select index: \(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text!))")
        
        itemsArray[indexPath.row].checked = !itemsArray[indexPath.row].checked
        tableView.reloadData()
        /*let cell=tableView.cellForRow(at: indexPath)
         if (cell?.accessoryType == UITableViewCellAccessoryType.none) {
         cell?.accessoryType = .checkmark
         }
         else{
         cell?.accessoryType = .none
         }*/
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add Item to List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        //TODO: - Declare alert
        let addItemAlert=UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        //TODO: - Declare and add action
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            //add item to table view
            let newItem=Item()
            newItem.title=textField.text!
            self.itemsArray.append(newItem)
            
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: newItem)
            
            self.defaults.set(encodedData, forKey: "todoArray2")
            //self.defaults.set(self.itemsArray, forKey: "todoArray")
            self.tableView.reloadData()
            
        }
        addItemAlert.addAction(action)
        action.isEnabled=false
        
        //MARK: - Declare and add textField to alert
        
        addItemAlert.addTextField { (addItemTextField) in
            addItemTextField.placeholder="Creat new item"
            textField=addItemTextField
            // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: addItemTextField, queue: OperationQueue.main, using:
                {_ in
                    // Being in this block means that something fired the UITextFieldTextDidChange notification.
                    
                    // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                    let textCount = addItemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    // If the text contains non whitespace characters, enable the Add Button
                    action.isEnabled = textIsNotEmpty
                    
            })
            
        }
        
        self.present(addItemAlert, animated: true, completion: nil)
        
        
    }
}

