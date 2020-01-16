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
    
    //var selectedDateDips: 
    
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
    }
    
    @IBAction func resetCounterButtonTouched(_ sender: Any) {
    }
    
    @IBAction func counterButtonTouched(_ sender: Any) {
    }
    
    
    
}
