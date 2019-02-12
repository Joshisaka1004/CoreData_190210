//
//  DetailVC.swift
//  CoreData_190210
//
//  Created by Joachim Vetter on 10.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class DetailVC: UITableViewController {

    
    var myDetailList = [Detail]()
    
    let myFetching = NSFetchRequest<Detail>(entityName: "Detail")
    
    var myContext2 = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: ToDoList? {
        didSet {
            loadIt()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDetailList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = myDetailList[indexPath.row].detailName
        return myCell
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var finalTextField = UITextField()
        
        let myAlert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let newItem = Detail(context: self.myContext2)
            newItem.detailName = finalTextField.text!
            newItem.parent = self.selectedCategory
            self.myDetailList.append(newItem)
            self.saveIt()
        }
        
        myAlert.addAction(myAction)
        myAlert.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        present(myAlert, animated: true, completion: nil)
    }
    
    func loadIt() {
        let myPredicate = NSPredicate(format: "parent.elements MATCHES %@", selectedCategory!.elements!)
        myFetching.predicate = myPredicate
    
        do {
            myDetailList = try myContext2.fetch(myFetching)
        }
        catch {
            print("This error is of kind \(error)")
        }
        tableView.reloadData()
    }
    
    func saveIt() {
        
        do {
            try myContext2.save()
        }
        catch {
            print("This error is of kind \(error)")
        }
        tableView.reloadData()
    }
}
