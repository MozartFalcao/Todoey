//
//  ViewController.swift
//  Todoey
//
//  Created by Mozart Falcão on 15/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggos","Destroy Demogorgon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    //MARK: - Tableview DataSource Methods
    
    //how to add a array on tableview cells ...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    // the number of rows in a tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
        
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        //checkmark on tableview
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        
        //selected row animation
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    


}

