//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mozart Falcão on 17/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //seting the tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //setting the cell text label of each row of TableView
        cell.textLabel?.text = categories[indexPath.row].name
        
        //return cell
        return cell
        
    }
    
    //the number of rows in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    
    //MARK : TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selected row animation
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //adjustments to prepare the data before send to performSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //segue destination
        let destinationVC = segue.destination as! TodoListViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: " Add Category ", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            
            self.saveCategory()
            
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategory()
    {
        do {
            try context.save()
        } catch  {
            print(" Error saving context Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        do {
            categories =  try context.fetch(Category.fetchRequest())
        } catch  {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}
