//
//  SearchTableViewController.swift
//  
//
//  Created by user137691 on 9/30/18.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate {
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        tableView.rowHeight=80
    }
    let defaultColor="1D9BF6"
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
    // MARK: - Edit and Delete actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            self.edit(at: indexPath)
        }
        editAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [editAction])
        configuration.performsFirstActionWithFullSwipe=true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.delete(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe=true
        return configuration
    }
    func  loadData()  {}
    func  loadDataWithSearchKeys() {}
    func edit(at indexPath:IndexPath){ }
    func delete(at indexPath:IndexPath){}
}
