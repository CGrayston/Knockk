//
//  AmmoTableViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import RealmSwift

class ObjectionsTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    
    // MARK: - Properties
    var notificationToken: NotificationToken? = nil
    let realm: Realm
    var pitch: Results<Pitch>
    var objections: Results<Objection>
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        // Give realm initial value
        self.realm = try! Realm()
        
        // Give pitch and obejctions initial values
        self.pitch = realm.objects(Pitch.self)
        self.objections = realm.objects(Objection.self)
        super.init(coder: coder)
    }
    
    // MARK: - Life Cycle Methods
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create pitch object first time running the app
        if pitch.count == 0 {
            // Create only Pitch object
            let myPitch = Pitch(title: "Pitch")
            
            try! realm.write {
                realm.add(myPitch)
            }
        }
        
        // Observe Objection Notifications
        notificationToken = objections.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                // Always apply updates in the following order: deletions, insertions, then modifications.
                // Handling insertions before deletions may result in unexpected behavior.
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toObjectionEditor" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? PitchObjectionEditorViewController else { return }
            
            // Pass objection to ObjectionEditorTableView
            let objection = objections[indexPath.row]
            destinationVC.objection = objection
        } else if segue.identifier == "toPitchEditor" {
            guard let destinationVC = segue.destination as? PitchObjectionEditorViewController else { return }
            
            // Pass pitch to ObjectionEditorTableView
            destinationVC.pitch = pitch.first
            
        }
        
    }
    
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Add New Objection", message: "Enter the objection here, after you can enter your response to said objection", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            let myTextField = (alertVC.textFields?.first)! as UITextField
            
            let objection = Objection()
            objection.title = myTextField.text!
            
            try! self.realm.write {
                self.realm.add(objection)
                //self.tableView.insertRows(at: [IndexPath(row: self.objections.count - 1, section: 0)], with: .automatic)
            }
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension ObjectionsTableViewController {
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return number of objections
        return objections.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let objection = objections[indexPath.row]
            
            try! self.realm.write {
                self.realm.delete(objection)
            }
            
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectionCell", for: indexPath)
        
        let objection = objections[indexPath.row]
        
        cell.textLabel?.text = objection.title
        
        return cell
    }
    
}
