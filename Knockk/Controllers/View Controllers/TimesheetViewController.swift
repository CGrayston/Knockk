//
//  TimesheetViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/13/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit

class TimesheetViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timeKnockingTextField: UITextField!
    
    // MARK: - Data Model
    var realmServices: RealmServices!
    
    // MARK: - Variables
    var time =  0
    var timer = Timer()
    var seconds = 0
    var minutes = 0
    var hours = 0
    
    let datePicker = UIDatePicker()
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(TimesheetViewController.doneButtonPressed))
        timeKnockingTextField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = UIDatePicker.Mode.countDownTimer
        datePicker.addTarget(self, action: #selector(TimesheetViewController.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.countDownDuration = TimeInterval(time)
        timeKnockingTextField.inputView = datePicker
        
        displayTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update selected date
        guard let currentDIPS = realmServices.currentDIPS,
            let selectedDate = realmServices.selectedDate else {
                print("Error unwrapping values initially set on HomePage")
                return
        }
        selectedDateLabel.text = selectedDate.returnDateFullTimeNone()
        //selectedDateLabel.text = "\(realmServices.currentDIPS?.date)"
        
        // Update time knocking
        time = currentDIPS.timeWorked
        displayTime()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        

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
    
    // Done button clicked
    @objc func doneButtonPressed() {
        time = Int(datePicker.countDownDuration)
        displayTime()
        view.endEditing(true)
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        // TODO - make it so it doesn't look editable
        //timeKnockingTextField.isSelected = false
        //datePicker.countDownDuration = TimeInterval(time)
        //        time = Int(datePicker.countDownDuration)
        //        displayTime()
    }
    
    // MARK: - Actions
    @IBAction func previousWorkday(_ sender: Any) {
        
    }
    
    @IBAction func nextWorkday(_ sender: Any) {
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        timer.invalidate()
        time = 0
        displayTime()
    }
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        if let label = startStopButton.titleLabel?.text {
            if label.isEqual("Start") {
                startStopButton.setTitle("Pause", for: .normal)
                resetButton.isEnabled = false
                resetButton.setTitle("", for: .normal)
                timeKnockingTextField.isEnabled = false
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimesheetViewController.addSecond), userInfo: nil, repeats: true)
            } else {
                startStopButton.setTitle("Start", for: .normal)
                resetButton.isEnabled = true
                resetButton.setTitle("Reset", for: .normal)
                timeKnockingTextField.isEnabled = true
                timer.invalidate()
            }
        }
    }
}

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
extension Date {
    func returnDateFullTimeNone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: self)
    }
}
