//
//  SearchTableViewController.swift
//  
//
//  Created by user137691 on 9/30/18.
//

import UIKit

class SearchTableViewController: UITableViewController,UISearchBarDelegate {
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
    func  loadData()  {
    }
    func  loadDataWithSearchKeys() {
    }
}
