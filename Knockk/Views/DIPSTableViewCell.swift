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
    @IBOutlet weak var counterButtonView: UIView!
    @IBOutlet weak var cellView: UIView!
    
    // MARK: - Properties
    var indexRow: Int?
    var delegate: DIPSTableViewCellDelegate! // Delgate
    
    // MARK: - Data Model
    var realmServices: RealmServices! {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 5
        cellView.layer.masksToBounds = true
        
        counterButtonView.layer.cornerRadius = 10
        counterButtonView.layer.masksToBounds = true
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
            let currentDIPS = realmServices.currentDIPS else {
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
        realmServices.update(currentDIPS, with: dict)
    }
    
    @IBAction func resetCounterButtonTouched(_ sender: Any) {
        // Unwrap counter button title and convert to integer value
        guard let counterTitle = counterButton.titleLabel?.text,
            var counterTitleAsInt = Int(counterTitle),
            let nameLabel = nameLabel.text,
            let currentDIPS = realmServices.currentDIPS else {
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
        realmServices.update(currentDIPS, with: dict)
        
    }
    
    @IBAction func counterButtonTouched(_ sender: Any) {
        // Unwrap counter button title and convert to integer value
        guard let counterTitle = counterButton.titleLabel?.text,
            var counterTitleAsInt = Int(counterTitle),
            let nameLabel = nameLabel.text,
            let currentDIPS = realmServices.currentDIPS else {
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
        realmServices.update(currentDIPS, with: dict)
        
    }
    
    @IBAction func chartsButtonTapped(_ sender: Any) {
        // When button is tapped, call delegate function on homePage to segue
        self.delegate.callSegueFromCell(nameLabel: "Soemthing")
    }
    
    // MARK: - Methods
    private func configure() {
        // Unwrap
        guard let currentDIPS = realmServices.currentDIPS else {
            print("Error unwrapping currentDIPS in private func configure")
            return
        }
        
        
        // Set cell title label and button count
        switch indexRow {
        case 0:
            nameLabel.text = "Doors"
            counterButton.setTitle("\(currentDIPS.doors)", for: .normal)
        case 1:
            nameLabel.text = "Interactions"
            counterButton.setTitle("\(currentDIPS.interactions)", for: .normal)
        case 2:
            nameLabel.text = "Homeowners Pitched"
            counterButton.setTitle("\(currentDIPS.pitches)", for: .normal)
        case 3:
            nameLabel.text = "Leads Generated"
            counterButton.setTitle("\(currentDIPS.leads)", for: .normal)
        case 4:
            nameLabel.text = "Come Back Later"
            counterButton.setTitle("\(currentDIPS.comeBacks)", for: .normal)
        case 5:
            nameLabel.text = "Appointments Set"
            counterButton.setTitle("\(currentDIPS.appointments)", for: .normal)
        case 6:
            nameLabel.text = "Lessons Taught"
            counterButton.setTitle("\(currentDIPS.lessons)", for: .normal)
        case 7:
            nameLabel.text = "ACs"
            counterButton.setTitle("\(currentDIPS.acs)", for: .normal)
        case 8:
            nameLabel.text = "WCs"
            counterButton.setTitle("\(currentDIPS.wcs)", for: .normal)
        default:
            fatalError("There should only be 9 cases in configure method")
        }
    }
}

// MARK: - Protocol
protocol DIPSTableViewCellDelegate {
    func callSegueFromCell(nameLabel: String)
}
