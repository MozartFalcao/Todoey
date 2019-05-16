//
//  ViewController.swift
//  Todoey
//
//  Created by Mozart Falcão on 15/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Mike", "Buy Eggos","Destroy Demogorgon"]
    
    //let defaults = UserDefaults.standard
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let items = defaults.array(forKey: "TodoLIstArray") as? [String]{
        //            itemArray = items
        //        }
        
        loadItems()
         
    }
    
    
    //MARK: - Tableview DataSource Methods
    
    //how to add a array on tableview cells ...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let itemRow = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = itemRow.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemRow.done ? .checkmark : .none
        
        //        if itemArray[indexPath.row].done == true
        //        {
        //            cell.accessoryType = .checkmark
        //        }
        //        else{
        //            cell.accessoryType = .none
        //        }
        //
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
        //        How to write this in a single row of code.
        //        if itemArray[indexPath.row].done == false
        //        {
        //            itemArray[indexPath.row].done = true
        //        }
        //        else
        //        {
        //            itemArray[indexPath.row].done = false
        //        }
        
        //checkmark on tableview
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        //        {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        //        else
        //        {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //
        //        }
        //
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        //HERE:
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //selected row animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        
        var textField = UITextField()
        
        // how to put a alert on screen and get data from user.
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {
            (action) in
            //what will hapen once the user clicks the Add Uten button on our UIAlert
            //self.itemArray.append(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //using user defaults...
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            
            
        }
        
        //text field on alert action
        alert.addTextField
            { (alertTextField) in
                alertTextField.placeholder = "Create new Item"
                textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems()
    {
        let enconder = PropertyListEncoder()
        
        
        do
        {
            let data = try enconder.encode(itemArray)
            try  data.write(to: dataFilePath!)
        }
        catch
        {
            print("Error enconding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!)
        {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error decoding item array \(error)")
            }
        }
    }
}

