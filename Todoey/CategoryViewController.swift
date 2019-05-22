//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mozart Falcão on 17/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    var bgCellColor: UIColor?
    //Using CoreData
    //var categories = [Category]()
    
    //using CoreDate
    //var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        loadCategory()
         
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //implementing SwipeTableViewCell
        //seting the tableview
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]
        {
            //setting the cell text label of each row of TableView
            cell.textLabel?.text = category.name
        
            guard let categoryColor = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            
        }
        
       // cell.backgroundColor = categories?[indexPath.row].backgroundCellColor
//
//        if let color = categories?[indexPath.row].backgroundCellColor
//        {
//            //cell.backgroundColor = UIColor(hexString: color)
//            cell.backgroundColor = color
//        }
//        else
//        {
//            cell.backgroundColor = bgCellColor
//            //bgCellColor = cell.backgroundColor
//        }
//        
        
       
        return cell
        
    }
    
    //the number of rows in the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Nil Coaleasing operator - check if the object or method whatever is nil, if is nil return on this case one.
        return categories?.count ?? 1
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: " Add Category ", style: .default) { (action) in
            
            //using coreData
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            //using CoreDate
            //self.categories.append(newCategory)
            
            self.save(category: newCategory)
            
            
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category)
    {
        do {
            
            try realm.write {
                realm.add(category)
            }
            
            
            //using CoreData
            //try context.save()
        } catch  {
            print(" Error saving context Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
       
        categories = realm.objects(Category.self)
        
        //using CoreData
        //        do {
        //            categories =  try context.fetch(Category.fetchRequest())
        //        } catch  {
        //            print("Error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]
        {
            do
            {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
            
        }
        
    }
    
}

