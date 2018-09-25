//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by user137691 on 9/17/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryTableViewController: UITableViewController {
    var categories:Results<Category>?
    let realm=try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if(categories==nil || categories?.count==0)
        {
            cell.textLabel?.text="No Category have been added yet"
            
        }else{
        cell.textLabel?.text=categories![indexPath.row].name
        }
        return cell
        
    }
     // MARK: - Add New Category
    @IBAction func AddButtonPressed(_ sender: Any) {
        var alertTextField=UITextField()
        let alert=UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let category=Category()
            category.name=alertTextField.text!
            if(self.categories?.contains{ $0.name.lowercased() == category.name.lowercased()} ?? false){
                ProgressHUD.showError("category with the same name found")
            }else{
                self.save(category: category)
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        addAction.isEnabled=false
        alert.addTextField { (textField) in
            textField.placeholder="Enter Category"
            alertTextField=textField
            // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                {_ in
                    // Being in this block means that something fired the UITextFieldTextDidChange notification.
                    
                    // Access the textField object from alertController.addTextField(configurationHandler:) above and get the character count of its non whitespace characters
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    // If the text contains non whitespace characters, enable the Add Button
                    addAction.isEnabled = textIsNotEmpty
                    
            })
            
        }
        
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
     // MARK: - Table view delegates
  /*  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            
            let alert=UIAlertController(title: "Edit Category", message: "",preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (categoryTextField) in
                categoryTextField.text=self.categoryArray[indexPath.row].name
                
            })
          
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                self.categoryArray[indexPath.row].name=alert.textFields?.first?.text
                self.loadData()
                
            }))
             alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
            
            self.present(alert, animated: true, completion: nil)
        })
       
        let deleteAction=UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.context.delete(self.categoryArray[indexPath.row])
            self.categoryArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        self.save()
        return[deleteAction,editAction]
    }
 */
     // MARK: - Seues section
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        destinationVC.selectedCategory=categories?[(tableView.indexPathForSelectedRow?.row)!]
    }
     // MARK: - Data Manipulation
    func save(category:Category)  {
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving data ")
        }
        tableView.reloadData()
    }
    func  loadData()  {
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
 // MARK: -  SearchBar Delegates
/*extension CategoryTableViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count==0){
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadData()
        }
        else{
            let request:NSFetchRequest<Category>=Category.fetchRequest()
            request.predicate=NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!)
            request.sortDescriptors=[NSSortDescriptor(key: "name", ascending: true)]
            loadData(with: request)
        }
        
    }
    
}*/
