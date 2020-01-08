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
            }
        })
    }

}

