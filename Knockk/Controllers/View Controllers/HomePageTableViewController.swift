//
//  HomePageTableViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import FirebaseDatabase
import RealmSwift

class HomePageTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var acGoalLabel: UILabel!
    @IBOutlet weak var wcGoalLabel: UILabel!
    
    // MARK: - Properties
    var dipsRealmResults : Results<DIPS>!
    
//    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.grabData()
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {

            self.grabData()
        }
        // Swift
        // Get the default Realm
        

    }
    
    func grabData() {
        let databaseRef = Database.database().reference()
        databaseRef.child("DIPS").observe(.value, with: {
            snapshot in
            print(snapshot)
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                // Convert into a dictionary that is very parsable
                guard let dictionary = snap.value as? [String : AnyObject] else {
                    return
                }
                let doors = dictionary["doors"] as! Int
                let interactions = dictionary["interactions"] as! Int
                
                let DIPSToAdd = DIPS()
                DIPSToAdd.doors = doors
                DIPSToAdd.interactions = interactions
                DIPSToAdd.writeToRealm()
                
                self.reloadData()
            }
        })
    }
    
    func reloadData() {
        // Grab from realm file and query the data
        dipsRealmResults = uiRealm.objects(DIPS.self) //.sorted(byKeyPath: "age", ascending: true).filter("name != nil")
        self.tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! DIPSTableViewCell
        
        if dipsRealmResults != nil {
            let cellName = dipsRealmResults[0].doors
            let cellCounterValue = dipsRealmResults[0].interactions
            cell.setCellValues(cellName: "\(cellName)", cellCounterValue: cellCounterValue)
        }
        
        
        
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    @IBAction func previousMonth(_ sender: Any) {
    }
    
    @IBAction func nextMonth(_ sender: Any) {
    }
    

}
