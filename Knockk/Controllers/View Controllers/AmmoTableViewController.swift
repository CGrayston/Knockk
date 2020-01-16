//
//  AmmoTableViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import RealmSwift

class AmmoTableViewController: UITableViewController {

    // MARK: - Outlets
    
    
    // MARK: - Properties
    var realm: Realm!
    var pitch: Results<Pitch> {
        get {
            return realm.objects(Pitch.self)
        }
    }
    
    var objectsArray: Results<Objection> {
        get {
            return realm.objects(Objection.self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try! Realm()
        
//        pitch = realm.objects(Pitch.self)
        
        if pitch.count == 0 {
            // Create only Pitch object
            let myPitch = Pitch(title: "Pitch")
            
            try! realm.write {
                realm.add(myPitch)
            }
        }
        
        //setupTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectsArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let objection = objectsArray[indexPath.row]
            
            try! self.realm.write {
                self.realm.delete(objection)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectionCell", for: indexPath)
        
        let objection = objectsArray[indexPath.row]
        
        cell.textLabel?.text = objection.title

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toObjectionEditor" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? PitchObjectionEditorViewController else { return }
            
            // Pass objection to ObjectionEditorTableView
            let objection = objectsArray[indexPath.row]
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
                self.tableView.insertRows(at: [IndexPath(row: self.objectsArray.count - 1, section: 0)], with: .automatic)
            }
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(addAction)
        present(alertVC, animated: true, completion: nil)
    }
    

}
