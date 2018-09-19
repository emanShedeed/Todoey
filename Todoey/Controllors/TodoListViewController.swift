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
    // @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var search: UISearchBar!
    var itemsArray=[Item]()
    var selectedCategory:Category?{
        didSet{
            loadData()
        }
    }
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        search.showsCancelButton = true
        // loadData()
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
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField1) in
                textField1.text = self.itemsArray[indexPath.row].title
            })
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                self.itemsArray[indexPath.row].title = alert.textFields!.first!.text!
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.context.delete(self.itemsArray[indexPath.row])
            self.itemsArray.remove(at: indexPath.row)
            tableView.reloadData()
            
        })
        self.saveData()
        return [deleteAction, editAction]
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
        let addAction=UIAlertAction(title: "Add", style: .default) { (action) in
            //add item to table view
            let newItem=Item(context: self.context)
            newItem.title=textField.text!
            newItem.category=self.selectedCategory
            self.itemsArray.append(newItem)
            
            self.saveData()
            
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
    
    func saveData()
    {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        tableView.reloadData()
    }
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(),searchPredict:NSPredicate?=nil)
    {
        let categoryPredicate=NSPredicate(format: "category.name Matches %@", (selectedCategory?.name)!)
        if(searchPredict==nil){
            request.predicate=categoryPredicate
        }else{
            let CompoundPredicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,searchPredict!])
            request.predicate=CompoundPredicate
        }
        
        do{
            itemsArray = try  context.fetch(request)
        }catch{
            print("Error fetching data")
        }
        tableView.reloadData()
    }
    func  loadDataWithSearchKeys() {
        let request:NSFetchRequest<Item>=Item.fetchRequest()
        let predicate=NSPredicate(format: "title CONTAINS [cd] %@", search.text!)
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, searchPredict: predicate)
        
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



