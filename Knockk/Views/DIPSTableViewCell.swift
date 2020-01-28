//
//  DIPSTableViewCell.swift
//  Knockk
//
//  Created by Chris Grayston on 1/15/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
// DIPS = Doors, Interactions, Pitches and Sales
class DIPSTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var counterButton: UIButton!
    
    var selectedDateDips: DIPS?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    func setCellValues(cellName: String, cellCounterValue: Int) {
        nameLabel.text = cellName
        counterButton.setTitle("\(cellCounterValue)", for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func minusOneButtonTouched(_ sender: Any) {
        // Unwrap counter button title and convert to integer value
        guard let counterTitle = counterButton.titleLabel?.text,
            var counterTitleAsInt = Int(counterTitle),
            let nameLabel = nameLabel.text,
            let selectedDateDIPS = selectedDateDips else {
                fatalError("Counter was not initilized properly")
        }
        
        // Update text
        if counterTitleAsInt == 0 {
            // No negative numbers - Nothing needs to be done
            return
        } else {
            counterTitleAsInt -= 1
            counterButton.setTitle(String(counterTitleAsInt), for: .normal)
        }
        
        // Update DIPS model
        var dict: [String: Any?] = [:]
        
        // Set cell title label and button count
        switch nameLabel {
        case "Doors":
            dict = ["doors": counterTitleAsInt]
        case "Interactions":
            dict = ["interactions": counterTitleAsInt]
        case "Homeowners Pitched":
            dict = ["pitches": counterTitleAsInt]
        case "Leads Generated":
            dict = ["leads": counterTitleAsInt]
        case "Come Back Later":
            dict = ["comeBacks": counterTitleAsInt]
        case "Appointments Set":
            dict = ["appointments": counterTitleAsInt]
        case "Lessons Taught":
            dict = ["lessons": counterTitleAsInt]
        case "ACs":
            dict = ["acs": counterTitleAsInt]
        case "WCs":
            dict = ["wcs": counterTitleAsInt]
        default:
            fatalError("Default case was hit in minusOneButtonTapped action")
        }
        
        // Update DIPS in realm
        RealmServices.shared.update(selectedDateDIPS, with: dict)
    }
    
    @IBAction func resetCounterButtonTouched(_ sender: Any) {
        // Unwrap counter button title and convert to integer value
        guard let counterTitle = counterButton.titleLabel?.text,
            var counterTitleAsInt = Int(counterTitle),
            let nameLabel = nameLabel.text,
            let selectedDateDIPS = selectedDateDips else {
                fatalError("Counter was not initilized properly")
        }
        
        // Update text
        if counterTitleAsInt == 0 {
            // No negative numbers - Nothing needs to be done
            return
        } else {
            counterTitleAsInt = 0
            counterButton.setTitle(String(counterTitleAsInt), for: .normal)
        }
        
        
        // Update DIPS model
        var dict: [String: Any?] = [:]
        
        // Set cell title label and button count
        switch nameLabel {
        case "Doors":
            dict = ["doors": counterTitleAsInt]
        case "Interactions":
            dict = ["interactions": counterTitleAsInt]
        case "Homeowners Pitched":
            dict = ["pitches": counterTitleAsInt]
        case "Leads Generated":
            dict = ["leads": counterTitleAsInt]
        case "Come Back Later":
            dict = ["comeBacks": counterTitleAsInt]
        case "Appointments Set":
            dict = ["appointments": counterTitleAsInt]
        case "Lessons Taught":
            dict = ["lessons": counterTitleAsInt]
        case "ACs":
            dict = ["acs": counterTitleAsInt]
        case "WCs":
            dict = ["wcs": counterTitleAsInt]
        default:
            fatalError("Default case was hit in counterButtonTapped action")
        }
        
        // Update DIPS in realm
        RealmServices.shared.update(selectedDateDIPS, with: dict)
        
    }
    
    @IBAction func counterButtonTouched(_ sender: Any) {
        // Unwrap counter button title and convert to integer value
        guard let counterTitle = counterButton.titleLabel?.text,
            var counterTitleAsInt = Int(counterTitle),
            let nameLabel = nameLabel.text,
            let selectedDateDips = selectedDateDips else {
                fatalError("Counter was not initilized properly")
        }
        
        // Update text
        counterTitleAsInt += 1
        counterButton.setTitle(String(counterTitleAsInt), for: .normal)
        
        // Update DIPS model
        var dict: [String: Any?] = [:]
        
        // Set cell title label and button count
        switch nameLabel {
        case "Doors":
            dict = ["doors": counterTitleAsInt]
        case "Interactions":
            dict = ["interactions": counterTitleAsInt]
        case "Homeowners Pitched":
            dict = ["pitches": counterTitleAsInt]
        case "Leads Generated":
            dict = ["leads": counterTitleAsInt]
        case "Come Back Later":
            dict = ["comeBacks": counterTitleAsInt]
        case "Appointments Set":
            dict = ["appointments": counterTitleAsInt]
        case "Lessons Taught":
            dict = ["lessons": counterTitleAsInt]
        case "ACs":
            dict = ["acs": counterTitleAsInt]
        case "WCs":
            dict = ["wcs": counterTitleAsInt]
        default:
            fatalError("Default case was hit in counterButtonTapped action")
        }
        
        // Update DIPS in realm
        RealmServices.shared.update(selectedDateDips, with: dict)
        
    }
    
    // MARK: - Methods
    func configure(with DIPSToPass: DIPS, indexRow: Int) {
        // Set selectedDIPS
        selectedDateDips = DIPSToPass
        
        // Set cell title label and button count
        switch indexRow {
        case 0:
            nameLabel.text = "Doors"
            counterButton.setTitle("\(DIPSToPass.doors)", for: .normal)
        case 1:
            nameLabel.text = "Interactions"
            counterButton.setTitle("\(DIPSToPass.interactions)", for: .normal)
        case 2:
            nameLabel.text = "Homeowners Pitched"
            counterButton.setTitle("\(DIPSToPass.pitches)", for: .normal)
        case 3:
            nameLabel.text = "Leads Generated"
            counterButton.setTitle("\(DIPSToPass.leads)", for: .normal)
        case 4:
            nameLabel.text = "Come Back Later"
            counterButton.setTitle("\(DIPSToPass.comeBacks)", for: .normal)
        case 5:
            nameLabel.text = "Appointments Set"
            counterButton.setTitle("\(DIPSToPass.appointments)", for: .normal)
        case 6:
            nameLabel.text = "Lessons Taught"
            counterButton.setTitle("\(DIPSToPass.lessons)", for: .normal)
        case 7:
            nameLabel.text = "ACs"
            counterButton.setTitle("\(DIPSToPass.acs)", for: .normal)
        case 8:
            nameLabel.text = "WCs"
            counterButton.setTitle("\(DIPSToPass.wcs)", for: .normal)
        default:
            fatalError("There should only be 9 cases in configure method")
        }
    }
}
