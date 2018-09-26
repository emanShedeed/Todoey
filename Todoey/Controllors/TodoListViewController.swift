//
//  ViewController.swift
//  Todoey
//
//  Created by user137691 on 9/5/18.
//  Copyright © 2018 user137691. All rights reserved.
//
import UIKit
import  RealmSwift
class TodoListViewController: UITableViewController {
    // @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var search: UISearchBar!
    var items:Results<Item>?
    let realm=try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        search.showsCancelButton = true
        // loadData()
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let itemObj=items?[indexPath.row]{
            cell.textLabel?.text = itemObj.title
            cell.accessoryType=itemObj.checked ? .checkmark :.none
            
        }else{
        cell.textLabel?.text="No Items Added"
        }
        return cell
    }
      override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
     let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
     let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
     alert.addTextField(configurationHandler: { (textField1) in
     textField1.text = self.items?[indexPath.row].title
     })
     alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
        if let itemObj=self.items?[indexPath.row]{
            do{
                try self.realm.write {
                    itemObj.title=alert.textFields!.first!.text!
                    
                }
            }catch{
                print("error updating item")
            }
        }
     self.tableView.reloadRows(at: [indexPath], with: .fade)
     }))
     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
     self.present(alert, animated: false)
     })
     
     let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
       if let itemObj=self.items?[indexPath.row]{
        do{
            try self.realm.write {
                self.realm.delete(itemObj)
                
            }
        }catch{
            print("error deleting item")
        }
        }

     tableView.reloadData()
     
     })
     return [deleteAction, editAction]
     }
    //MARK: - Tableview Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item=items?[indexPath.row]{
            do{
           try  realm.write {
            item.checked = !item.checked
            }
            }catch{
                print("error updating item")
            }
        tableView.reloadData()
        }
       
        //itemsArray[indexPath.row].checked = !itemsArray[indexPath.row].checked
        // saveData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add Item to List
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        //TODO: - Declare alert
        let addItemAlert=UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        
        //TODO: - Declare and add action
        let addAction=UIAlertAction(title: "Add", style: .default) { (action) in
            //add item to table view
            
            if let currentCategory=self.selectedCategory{
                
                
                do{
                    try self.realm.write {
                        let newItem=Item()
                        newItem.title=textField.text!
                        currentCategory.items.append(newItem)
                        
                    }
                }catch{
                    print("error saving items")
                }
            }
            self.tableView.reloadData()
        }
        addItemAlert.addAction(addAction)
        addItemAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //as in the begin the text field is empty so disable the button
        addAction.isEnabled=false
        
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
                    addAction.isEnabled = textIsNotEmpty
                    
            })
            
        }
        
        self.present(addItemAlert, animated: true, completion: nil)
        
        
    }
    
  
   func loadData()
    {
       items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    func  loadDataWithSearchKeys() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        items=items?.filter(NSPredicate(format: "title CONTAINS[cd] %@", search.text!)).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
}
extension TodoListViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text?.count==0){
            searchBarCancelButtonClicked(searchBar)
        }
        else{
            loadDataWithSearchKeys()
            
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count==0){
            searchBarCancelButtonClicked(searchBar)
        }
        else{
            loadDataWithSearchKeys()
        }
        
    }
    
}



