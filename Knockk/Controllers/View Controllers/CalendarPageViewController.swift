//
//  CalendarPageViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/10/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit

class CalendarPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var Calendar: UICollectionView!
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var DaysInMonths = [31,29,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int() // The number of empty boxes at the start of the current month
    
    var nextNumberOfEmptyBox = Int() // the same with above but with the next month
    
    var previousNumberOfEmptyBox = 0 // the same as above with the prev month
    
    var direction = 0 // = 0 if we are at the current month, = 1 if we are in a future month, = -1 if we are in a past month
    
    var positionIndex = 0 // store the above vars of the empty boxes
    
    var leapYearCounter = 4 // 2 because the next time February has 29 days is in two years
    
    var dayCounter = 0
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = Months[month]
        MonthLabel.text = "\(currentMonth) \(year)"
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
    }
    
    // MARK: - Actions
    @IBAction func previousMonth(_ sender: Any) {
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            direction = -1

            if leapYearCounter > 0 {
                leapYearCounter -= 1
                DaysInMonths[1] = 29
            }
            
            if leapYearCounter == 0 {
                DaysInMonths[1] = 29
                leapYearCounter = 4
            }
            
            if leapYearCounter == 0 {
                DaysInMonths[1] = 28
                leapYearCounter = 4
            } else {
                DaysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            month -= 1
            direction = -1

            getStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            direction = 1
            
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 4 {
                DaysInMonths[1] = 29
            }
            
            if leapYearCounter == 5 {
                leapYearCounter = 1
                DaysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            direction = 1

            getStartDateDayPosition()
            
            month += 1

            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    // MARK: - Methods
    
    // Gives us the number of empty boxes
    func getStartDateDayPosition() {
        switch direction {
        // At current month
        case 0:
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
        // Future month
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + DaysInMonths[month])%7
            positionIndex = nextNumberOfEmptyBox
            
        // Past month
        case -1:
            previousNumberOfEmptyBox = (7 - (DaysInMonths[month] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
            
        default:
            fatalError()
        }
    }
    

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of days in the month + the number of "empty boxes based on the direction we are going
        switch direction {
        case 0:
            return DaysInMonths[month] + numberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1...:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 {
            cell.isHidden = true
        }
        
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day{
            cell.Circle.isHidden = false
            cell.backgroundColor = UIColor.orange
            
            
        }
        return cell
    }

}
