//
//  ViewController.swift
//  Todoey
//
//  Created by user137691 on 9/5/18.
//  Copyright © 2018 user137691. All rights reserved.
//
import UIKit
import  CoreData
class TodoListViewController: UITableViewController {
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    let defaults=UserDefaults.standard
    var itemsArray=[Item]()
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
        
        itemsArray[indexPath.row].checked = !itemsArray[indexPath.row].checked
        saveData()
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
            
            let newItem=Item(context: self.context)
            newItem.title=textField.text!
            self.itemsArray.append(newItem)
            
            self.saveData()
            
        }
        addItemAlert.addAction(action)
        //as in the begin the text field is empty so disable the button
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
    func saveData()
    {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    func loadData()
    {
        let request : NSFetchRequest<Item>=Item.fetchRequest()
        do{
            itemsArray = try  context.fetch(request)
        }catch{
            print("Error fetching data")
        }
    }
    
}
        


