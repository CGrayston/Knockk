//
//  TimesheetViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/13/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import RealmSwift

class TimesheetViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timeKnockingTextField: UITextField!
    
    @IBOutlet weak var workDayMinus1Label: UILabel!
    @IBOutlet weak var workdayMinus2Label: UILabel!
    @IBOutlet weak var workdayMinus3Label: UILabel!
    
    @IBOutlet weak var hoursWorkedMinus1: UILabel!
    @IBOutlet weak var hoursWorkedMinus2: UILabel!
    @IBOutlet weak var hoursWorkedMinus3: UILabel!
    
    // MARK: - Data Model
    var realmServices: RealmServices!
    
    // MARK: - Variables
    var time =  0
    var backgroundDate: Date?
    var timer = Timer()
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    let datePicker = UIDatePicker()
    
    // MARK: - Initializers
    deinit {
        // TODO - Figure out if we really need this
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation bar
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.vivintOrange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Set up TimesheetVC
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(TimesheetViewController.doneButtonPressed))
        timeKnockingTextField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        datePicker.addTarget(self, action: #selector(TimesheetViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.countDownDuration = TimeInterval(time)
        timeKnockingTextField.inputView = datePicker
        
        
        // Display time initially
        displayTime()
        
        // Set date label and update time fro mrealmServices
        updateTimesheetForSelectedDate()
        
        // Create observers for when selected date is changed
        createObservers()
    }
    //    override func viewDidAppear(_ animated: Bool) {
    //        print("Soemthing")
    //    }
    // MARK: - Notification Methods
    
    func createObservers() {
        // Set up home page observer - Called when selected date is changed
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.updateTimesheetForSelectedDate), name: Constants.Notifications.selectedDateChangedNotification, object: nil)
        
        // Notification for when app enters the background
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.didEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        // Notification for when app enters the foreground
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.willEnterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Noification if app is backgrounded in the form of a phone call
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.didEnterBackground(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        // Noification if foregrounded after a phone call is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.willEnterForeground(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)

        
        // Noification if foregrounded after a phone call is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(TimesheetViewController.didEnterBackground(notification:)), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    @objc func didEnterBackground(notification: Notification) {
        // If timer is running
        if realmServices.isClockedIn {
            // Save current timeWorked value
            updateTimeWorkedInRealm(time: time)
            
            // Pause the timer
            timer.invalidate()
            
            // Set backgrounded date
            backgroundDate = Date()
        }
    }
    
    @objc func willEnterForeground(notification: Notification) {
        // Only execute if backgroundDate has been set
        guard let backgroundDate = backgroundDate else {
            return
        }
        
        // Update time - with the seconds it was backgrounded
        let difference = Calendar.current.dateComponents([.second], from: backgroundDate, to: Date())
        if let seconds = difference.second {
            time += seconds
        }
        
        // Set backgrounded date to nil
        self.backgroundDate = nil
        
        // Restart the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimesheetViewController.addSecond), userInfo: nil, repeats: true)
        
        // Save new timeWorked value
        updateTimeWorkedInRealm(time: time)
        
    }
    
    @objc func updateTimesheetForSelectedDate() {
        // Unwrap currentDIPS and selectedDate
        guard let currentDIPS = realmServices.currentDIPS,
            let selectedDate = realmServices.selectedDate else {
                print("Error unwrapping values initially set on HomePage")
                return
        }
        
        // Set selectedDate label
        selectedDateLabel.text = selectedDate.returnDateFullTimeNone()
        
        // Set Last 3 workdays labels - TODO
        //setLast3Workdays()
        
        // Update time display - Only runs when selectedDate is changed
        time = currentDIPS.timeWorked
        displayTime()
    }
    
    private func setLast3Workdays() {
        // Get selectedDate - Should have just been updated
        // TODO
        // Query/Filter for last 3 workdays
        //let realm = try! Realm()
        guard let selectedDate = realmServices.selectedDate else {
            return
        }
        
        let dateStart = Calendar.current.startOfDay(for: selectedDate)
        let firstDate = Date(timeIntervalSince1970: 0)
        //let predicate = NSPredicate(format: "timeWorked > 0 AND date < %@", dateStart)
        
        //        let last3Workdays = realmServices.dipsRealmResults?.filter("timeWorked > 0 AND date < %@ AND date > %@", dateStart, firstDate).sorted(byKeyPath: "date", ascending: false)
        //
        //        for i in 0..<2 {
        //            let last3Workday = last3Workdays?[i]
        //            print(last3Workday)
        //        }
        //        print("Something")
        // Update labels with that information
        
        //        if let last3Workdays = last3Workdays,
        //            let workDayMinus1 = last3Workdays[0] {
        //            workDayMinus1Label.text = workDayMinus1
        //        }
        
        
    }
    
    // MARK: - Functions
    @objc func addSecond() {
        time += 1
        
        displayTime()
    }
    
    func displayTime() {
        hours = time / 3600
        minutes = (time - (hours * 3600)) / 60
        seconds = time % 60
        
        timeKnockingTextField.text =
            (hours == 1 ? "\(hours) hr " : "\(hours) hrs ") +
            (minutes == 1 ? "\(minutes) min " : "\(minutes) mins ") +
            (seconds == 1 ? "\(seconds) sec" : "\(seconds) secs")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func doneButtonPressed() {
        time = Int(datePicker.countDownDuration)
        displayTime()
        view.endEditing(true)
        
        // Save new timeWorked value
        updateTimeWorkedInRealm(time: time)
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        // TODO - make it so it doesn't look editable
        //timeKnockingTextField.isSelected = false
        //datePicker.countDownDuration = TimeInterval(time)
        //        time = Int(datePicker.countDownDuration)
        //        displayTime()
    }
    
    func updateTimeWorkedInRealm(time: Int) {
        // Update realm timer value to current time value
        guard let currentDIPS = realmServices.currentDIPS else {
            print("Problem unwrapping currentDIPS in TimesheetVC")
            return
        }
        
        let dict = ["timeWorked": time]
        realmServices.update(currentDIPS, with: dict)
    }
    
    // MARK: - Actions
    @IBAction func previousWorkday(_ sender: Any) {
        // See if there are DIPS from a previous day
        // Get date value for one day prior to current selected date
        guard let unwrappedSelectedDate = realmServices.selectedDate else {
            print("Error unwrapping selected date")
            return
        }
        let newDate = Date(timeInterval: -86400, since: unwrappedSelectedDate)
        
        // Make sure we have a DIPS entry for previous date
        guard let oldestDIPSDate = realmServices.dipsRealmResults?.sorted(byKeyPath: "date", ascending: true).first?.date else {
            print("Error: Got to timesheetVC without ever creating even one DIPS object, should be impossible")
            return
        }
        
        if newDate.compare(oldestDIPSDate) == .orderedAscending {
            presentAlert(withTitle: "No DIPS for this date", message: "Please return to the home page and create a past DIPS entry from there")
            return
        }
        
        // Make sure timer is stopped
        if realmServices.isClockedIn {
            presentAlert(withTitle: "Timer running!", message: "Please pause timer before going to previous workday.")
            return
        }
        
        // Set selectedDate as declared date value
        realmServices.selectedDate = newDate
    }
    
    @IBAction func nextWorkday(_ sender: Any) {
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
            presentAlert(withTitle: "Timer running!", message: "Please pause timer before going to next workday.")
            return
        }
        
        // Set selectedDate as declared date value
        realmServices.selectedDate = newDate
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        time = 0
        displayTime()
        
        // Update timeWorked to 0
        updateTimeWorkedInRealm(time: 0)
        
        // Set isClockedIn to false
        realmServices.isClockedIn = false
    }
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        if let label = startStopButton.titleLabel?.text {
            if label.isEqual("Start") {
                // Start - Set up buttons
                // Only pause will be displayed on right button
                startStopButton.setTitle("Pause", for: .normal)
                resetButton.isEnabled = false
                resetButton.setTitle("", for: .normal)
                timeKnockingTextField.isEnabled = false
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimesheetViewController.addSecond), userInfo: nil, repeats: true)
                
                // Set isClockedIn to true
                realmServices.isClockedIn = true
            } else {
                // Pause - Set up buttons
                startStopButton.setTitle("Start", for: .normal)
                resetButton.isEnabled = true
                resetButton.setTitle("Reset", for: .normal)
                timeKnockingTextField.isEnabled = true
                timer.invalidate()
                
                // Update realm timer value to current time value
                updateTimeWorkedInRealm(time: time)
                
                // Set isClockedIn to false
                realmServices.isClockedIn = false
            }
        }
    }
}

// MARK: - UIToolbar Extension

extension UIToolbar {
    func ToolbarPiker(mySelect : Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.orange
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

// MARK: - Date Extension

extension Date {
    func returnDateFullTimeNone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
    
    func returnDateShortTimeNone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
}
