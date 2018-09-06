//
//  ViewController.swift
//  Todoey
//
//  Created by user137691 on 9/5/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
var itemsArray=["Work","Home","Shopping"]
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    //MARK: - Tableview Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        
        return cell
    }
    //MARK: - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("you select index: \(String(describing: tableView.cellForRow(at: indexPath)?.textLabel?.text!))")
     
        let cell=tableView.cellForRow(at: indexPath)
        if (cell?.accessoryType == UITableViewCellAccessoryType.none) {
            cell?.accessoryType = .checkmark
        }
        else{
            cell?.accessoryType = .none
        }
         tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

