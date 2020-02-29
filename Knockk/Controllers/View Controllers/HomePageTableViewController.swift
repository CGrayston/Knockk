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

class HomePageTableViewController: UITableViewController, DIPSTableViewCellDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var acGoalLabel: UILabel!
    @IBOutlet weak var wcGoalLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    // MARK: - Properties
    
    // MARK: - Data Model
    var realmServices: RealmServices!
    
    // MARK: - Initializers
    deinit {
        // TODO - Figure out if we really need this
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up home page
        setUpHomePage()
        overrideUserInterfaceStyle = .light
        
        // TODO - Notification whenever there is a change in the UI
        createObservers()
        
        // Remove
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.vivintOrange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.view.backgroundColor = Constants.Colors.vivintOrange
        self.headerView.backgroundColor = Constants.Colors.vivintOrange
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: - Notification Methods
    
    func createObservers() {
        // Set up home page observer - Called when selected date is changed
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageTableViewController.setUpHomePage), name: Constants.Notifications.selectedDateChangedNotification, object: nil)
    }
    
    @objc func setUpHomePage() {
        // Filter for DIPS from selected date
        guard let userUID = realmServices.userUID,
            let selectedDate = realmServices.selectedDate,
            let dipsRealmResults = realmServices.dipsRealmResults else {
                print("Error unwrapping values initially set on HomePage")
                return
        }
        let filterValue = "\(userUID)+\(dateShortTimeNoneFormatter(fromDate: selectedDate))"
        let currentDIPS = dipsRealmResults.filter("employeePlusDate == '\(filterValue)'").first
        
        // Query for user information matching logged in FireBase user
        let predicate = NSPredicate(format: "uid = %@", realmServices.userUID)
        guard let currentUser = realmServices.userRealmResults?.filter(predicate).first else {
            print("Error: No user profile, this should have returned in the search query")
            return
        }
        // Set currentUser
        realmServices.currentUser = currentUser
        
        // TODO - Set up AC and WC Goal labels
        setUpGoalsLabels()
        
        // Set up date label
        selectedDateLabel.text = dateFullTimeNoneFormatter(fromDate: selectedDate)
        
        // Check if there is a DIPS entry for today
        if currentDIPS != nil {
            // Set current DIPS
            realmServices.currentDIPS = currentDIPS
        } else {
            // No DIPS exist for current date
            // Create DIPS Realm Object
            let newDIPS = DIPS(employeeUID: userUID, date: selectedDate)
            
            // Add DIPS Realm Object
            realmServices.create(with: newDIPS)
            realmServices.currentDIPS = newDIPS
            
            // Alert that new DIPS
            
            let dateString = dateFullTimeNoneFormatter(fromDate: selectedDate)
            let alertVC = UIAlertController(title: "New DIPS", message: "New DIPS were created for date: \(dateString)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
            alertVC.addAction(cancelAction)
            present(alertVC, animated: true, completion: nil)
        }
        
        // Reload table with data from new date
        tableView.reloadData()
        
    }
    
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
    
    func setUpGoalsLabels() {
        guard let currentUser = realmServices.currentUser else {
            print("Error: No User logged in")
            return
        }
        acGoalLabel.text = "AC Weekly Goal Progress: x/\(currentUser.acGoal)"
        wcGoalLabel.text = "WC Weekly Goal Progress: x/\(currentUser.wcGoal)"
    }
    
    
    // MARK: - Actions
    
    @IBAction func previousDate(_ sender: Any) {
        // Get date value for one day prior to current selected date
        guard let unwrappedSelectedDate = realmServices.selectedDate else {
            print("Error unwrapping selected date")
            return
        }
        let newDate = Date(timeInterval: -86400, since: unwrappedSelectedDate)
        
        // Make sure timer is stopped
        if realmServices.isClockedIn {
            presentAlert(withTitle: "Timer running!", message: "Please pause timer on the Timesheet page before going to previous workday.")
            return
        }
        
        // Set selectedDate as declared date value
        realmServices.selectedDate = newDate
    }
    
    @IBAction func nextDate(_ sender: Any) {
        // Get date value for the day after the current selected date
        guard let unwrappedSelectedDate = realmServices.selectedDate else {
            print("Error unwrapping selected date")
            return
        }
        let newDate = Date(timeInterval: 86400, since: unwrappedSelectedDate)
        
        // Make sure the date we are navigating to is not a future date
        if newDate.compare(Date()) == .orderedDescending {
            presentAlert(withTitle: "Day hasn't happened yet", message: "Can't navigate to a future date...")
            return
        }
        
        // Make sure timer is stopped
        if realmServices.isClockedIn {
            presentAlert(withTitle: "Timer running!", message: "Please pause timer on the Timesheet page before going to next workday.")
            return
        }
        
        // Set selectedDate as declared date value
        realmServices.selectedDate = newDate
    }
    
    // MARK: - Delegate Function
    func callSegueFromCell(nameLabel: String) {
        // Segue to ChartsViewController
        self.performSegue(withIdentifier: "toChartsViewController", sender: nil)
    }
    
    
}

// MARK: - Table View Data Source

extension HomePageTableViewController {

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return 9 because that's how many categories we want
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath) as! DIPSTableViewCell
        
        // Configure custom cell
        cell.indexRow = indexPath.row
        cell.realmServices = realmServices
        cell.delegate = self
        
        
        //cell.configure(with: currentDIPS, indexRow: indexPath.row)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettingsVC" {
            guard let destinationVC = segue.destination as? SettingsViewController else {
                return
            }
            destinationVC.realmServices = self.realmServices
            
            // Set up back button for destinationVC
            let backItem = UIBarButtonItem()
            backItem.title = ""
            backItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            backItem.tintColor = .white
            navigationItem.backBarButtonItem = backItem
        }
        
        // Segue is being called when charts button is tapped
        // Want to pass the data model
        if segue.identifier == "toChartsViewController" {
            // Make sure we are segueing to correct VC
            guard let destinationVC = segue.destination as? ChartsViewController else {
                return
            }
            
            // Pass data model
            destinationVC.realmServices = self.realmServices
        }
    }
    


}

// MARK: - Create Alert Extension
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
