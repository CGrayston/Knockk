//
//  HomePageTableViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import RealmSwift

class HomePageTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var acGoalLabel: UILabel!
    @IBOutlet weak var wcGoalLabel: UILabel!
    
    // MARK: - Properties
    var dipsRealmResults : Results<DIPS>!
    
    var currentDIPS: DIPS?
    
    var selectedDate: Date?
    
    var userUID: String {
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("Non authenticted user shouldn't have gotten to this point")
        }
        return uid
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Up Realm and query DIPS realm objects
        let realm = RealmServices.shared.realm
        dipsRealmResults = realm.objects(DIPS.self)
        
        // Since ViewDidLoad - Get today's date
        selectedDate = Date()
        
        // Set up home page
        setUpHomePage(with: selectedDate!)
        
        
        // TODO - Notification whenever there is a change in the UI
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Helper Methods
    func dateFullTimeNoneFormatter(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    func dateShortTimeNoneFormatter(fromDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    
    
    func setUpHomePage(with date: Date) {
        // Filter for DIPS from selected date
        let filterValue = "\(userUID)+\(dateShortTimeNoneFormatter(fromDate: date))"
        currentDIPS = dipsRealmResults.filter("employeePlusDate == '\(filterValue)'").first
        
        // Set up date label
        selectedDateLabel.text = dateFullTimeNoneFormatter(fromDate: date)
        
    
        // Check if there is a DIPS entry for today
        if currentDIPS == nil {
            // No DIPS exist for current date
            // Create DIPS Realm Object
            let newDIPS = DIPS(employeeUID: userUID, date: date)
            
            // Add DIPS Realm Object
            RealmServices.shared.create(with: newDIPS)
            currentDIPS = newDIPS
            
            // Alert that new DIPS
            if let date = selectedDate {
                let dateString = dateFullTimeNoneFormatter(fromDate: date)
                let alertVC = UIAlertController(title: "New DIPS", message: "New DIPS were created for date: \(dateString)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                alertVC.addAction(cancelAction)
                present(alertVC, animated: true, completion: nil)
            } else {
                fatalError("Bad date input in setUpHomePage")
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func previousDate(_ sender: Any) {
        // Get date value for one day prior to current selected date
        guard let unwrappedSelectedDate = selectedDate else {
            print("Error unwrapping selected date")
            return
        }
        let newDate = Date(timeInterval: -86400, since: unwrappedSelectedDate)
        
        // Set selectedDate as declared date value
        self.selectedDate = newDate
        
        // Set up home page with data from selected date
        setUpHomePage(with: newDate)
        
        // Reload table with data from new date
        tableView.reloadData()
    }
    
    @IBAction func nextDate(_ sender: Any) {
        // Get date value for the day after the current selected date
        guard let unwrappedSelectedDate = selectedDate else {
            print("Error unwrapping selected date")
            return
        }
        let newDate = Date(timeInterval: 86400, since: unwrappedSelectedDate)
        
        // Make sure the date we are navigating to is not a future date
        if newDate.compare(Date()) == .orderedDescending {
            presentAlert(withTitle: "Day hasn't happened yet", message: "Can't navigate to a future date...")
            return
        }
        
        // Set selectedDate as declared date value
        self.selectedDate = newDate
        
        // Set up home page with data from selected date
        setUpHomePage(with: newDate)
        
        // Reload table with data from new date
        tableView.reloadData()
    }
    
    
}

// MARK: - Table view data source
extension HomePageTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return 9 because that's how many categories we want
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! DIPSTableViewCell
        
        guard let currentDIPS = currentDIPS else {
            print("cureentDIPS not set")
            return UITableViewCell()
        }
        // Configure custom cell
        cell.configure(with: currentDIPS, indexRow: indexPath.row)
        
        
        return cell
    }
}

extension UIViewController {

  func presentAlert(withTitle title: String, message : String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("You've pressed OK Button")
    }
    alertController.addAction(OKAction)
    self.present(alertController, animated: true, completion: nil)
  }
}
