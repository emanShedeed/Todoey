//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by user137691 on 9/17/18.
//  Copyright © 2018 user137691. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryTableViewController: SearchTableViewController {
    
    @IBOutlet weak var search: UISearchBar!
    var categories:Results<Category>?
    let realm=try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        search.showsCancelButton=true
        loadData()
        tableView.separatorStyle = .none
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
            cell.backgroundColor=UIColor(hexString:categories![indexPath.row].backgroundColor)
            if let colour=UIColor(hexString: categories![indexPath.row].backgroundColor){
             cell.textLabel?.textColor=ContrastColorOf(colour, returnFlat: true)
            }
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
            category.backgroundColor=UIColor.randomFlat.hexValue()
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

    // MARK: - Seues section
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        if let indexPath=tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory=categories?[indexPath.row]
        }
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
    override func  loadData()  {
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    override func  loadDataWithSearchKeys() {
         categories = realm.objects(Category.self)
         categories=categories?.filter(NSPredicate(format: "name CONTAINS[cd] %@", search.text!)).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    override func edit(at indexPath: IndexPath) {
        let alert=UIAlertController(title: "Edit Category", message: "",preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (categoryTextField) in
            categoryTextField.text=self.categories?[indexPath.row].name ?? ""
            
        })
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            if let categoryObj=self.categories?[indexPath.row]{
                do{
                    try self.realm.write {
                        categoryObj.name=(alert.textFields?.first?.text)!
                    }
                }catch{
                    print("error updating category")
                }
            }
            self.loadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    override func delete(at indexPath: IndexPath) {
        if let categoryObj=self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryObj)
                }
            }catch{
                print("error updating category")
            }
            tableView.reloadData()
        }
    }
    
}


