//
//  ViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 11/26/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit
import FirebaseDatabase
import RealmSwift

class TableViewController: UITableViewController {
    override func viewDidLoad() {
        grabData()
    }
    
    var users : Results<User>!
    
    func grabData() {
        let databaseRef = Database.database().reference()
        databaseRef.child("users").observe(.value, with: {
            snapshot in
            print(snapshot)
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                // Convert into a dictionary that is very parsable
                guard let dictionary = snap.value as? [String : AnyObject] else {
                    return
                }
                let name = dictionary["Name"] as? String
                let age = dictionary["Age"] as? Int
                
                let UserToAdd = User()
                UserToAdd.name = name
                UserToAdd.age.value = age
                UserToAdd.writeToRealm()
                
                self.reloadData()
            }
        })
    }
    
    func reloadData() {
        // Grab from realm file and query the data
        users = uiRealm.objects(User.self).sorted(byKeyPath: "age", ascending: true).filter("name != nil")
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "main")
        
        cell.textLabel?.text = users[indexPath.row].name
        if let age = users[indexPath.row].age.value {
            cell.detailTextLabel?.text = String(describing: age)
        }
        
        
        return cell
    }

}

