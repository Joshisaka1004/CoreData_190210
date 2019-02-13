//
//  ViewController.swift
//  CoreData_190210
//
//  Created by Joachim Vetter on 10.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class ToDoVC: UITableViewController {

    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var myList = [ToDoList]()
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var myFetching = NSFetchRequest<ToDoList>(entityName: "ToDoList")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearchBar.delegate = self
        loadIt()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = myList[indexPath.row].elements
        return myCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            let destinationVC = segue.destination as! DetailVC
            if let myIndexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = myList[myIndexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var finalTextField = UITextField()
        
        let myAlert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let newItem = ToDoList(context: self.myContext)
            newItem.elements = finalTextField.text!
            self.myList.append(newItem)
            self.tableView.reloadData()
        }
        
        myAlert.addAction(myAction)
        myAlert.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        present(myAlert, animated: true, completion: nil)
    }
    
    func loadIt() {
        print("here is my load function")
        
        do {
            myList = try myContext.fetch(myFetching)
        }
        catch {
            print("This error is of kind \(error)")
        }
        tableView.reloadData()
    }
    
    func saveIt() {
        
        do {
            try myContext.save()
        }
        catch {
            print("This error is of kind \(error)")
        }
        tableView.reloadData()
    }
}

extension ToDoVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        myFetching.predicate = NSPredicate(format: "elements CONTAINS [cd] %@", mySearchBar.text!)
        myFetching.sortDescriptors = [NSSortDescriptor(key: "elements", ascending: true)]
        if searchBar.text == "" {
            myFetching = NSFetchRequest<ToDoList>(entityName: "ToDoList")
        }
        loadIt()
    }
    
}
