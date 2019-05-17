//
//  ViewController.swift
//  Todoey
//
//  Created by Mozart Falcão on 15/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    //var itemArray = ["Find Mike", "Buy Eggos","Destroy Demogorgon"]
    
    //let defaults = UserDefaults.standard
    var itemArray = [Item]()
    
    //didset - trigger that starts before the variable is set.
    var selectedCategory : Category? {
        didSet{
                loadItems()
        }
    }
    
    //this line is used in the case to save something in a plist.
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //how to call a appdelegate class and get a singleton "method" in this case persistentContainer
    //TODO: view AppDelegate class//
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let items = defaults.array(forKey: "TodoLIstArray") as? [String]{
        //            itemArray = items
        //        }
        
        
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
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    func saveItems() {
        do{
            try context.save()
            
        }
        catch
        {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //adding more than one predicate in the same load request. coz I'll use result for load data and to searchbar.
        //doing the optional wrapping
        if let addtionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
           itemArray =  try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
         tableView.reloadData()
        
    }
    
    
    //function using a encoder and decoder methods...
    //    func saveItems()
    //    {
    //        let enconder = PropertyListEncoder()
    //
    //
    //        do
    //        {
    //            let data = try enconder.encode(itemArray)
    //            try  data.write(to: dataFilePath!)
    //        }
    //        catch
    //        {
    //            print("Error enconding item array, \(error)")
    //        }
    //
    //        self.tableView.reloadData()
    //    }
    //
    //    func loadItems()
    //    {
    //        if let data = try? Data(contentsOf: dataFilePath!)
    //        {
    //            let decoder = PropertyListDecoder()
    //            do{
    //                itemArray = try decoder.decode([Item].self, from: data)
    //            }
    //            catch
    //            {
    //                print("Error decoding item array \(error)")
    //            }
    //        }
    //    }
    
    
}

//MARK: - Searchbar methods

//how to create a extesion from another class delegate.
extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //line to sort the results
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with:request, predicate: NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!))

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

            //manages the execution of work itens. Threds
            DispatchQueue.main.async {
                //go to original state before the searchbar was activated
                searchBar.resignFirstResponder()

            }


        }

    }
    
}
