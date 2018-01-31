//
//  ViewController.swift
//  coreDataTutorial
//
//  Created by Mohamed on 1/30/18.
//  Copyright © 2018 Mohamed. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.dataSource = self
        getData()
   
    }

    func getData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "People")
        
        do{
            people = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Details", message: "Add a new name and phone number", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type a name"
        }
        
        alert.addTextField { (textField1) in
            textField1.placeholder = "Type phone Number"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            
            if let textfield = alert.textFields?.first, let textfield1 = alert.textFields?[1] {
                let name = textfield.text!
                let phoneNum = textfield1.text!
               
                self.save(name: name, phoneNum: phoneNum)
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        let person = people[indexPath.row]
        let name = person.value(forKey: "name") as? String ?? ""
        let phoneNumber = person.value(forKey: "phoneNumber") as? String ?? ""
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = phoneNumber
        return cell
    }
    
    func save(name: String, phoneNum: String){
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appdelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "People", in: managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //here we insert data
        person.setValue(name, forKey: "name")
        person.setValue(phoneNum, forKey: "phoneNumber")
        
        //save data here into our object
        do{
            try managedContext.save()
            people.append(person)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    
}


