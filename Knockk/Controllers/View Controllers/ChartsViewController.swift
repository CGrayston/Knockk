//
//  ChartsViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 2/21/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit

class ChartsViewController: UIViewController {

    // MARK: - Properties
    private var chartDisplayType: ChartsDisplayType = .week
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var selectedDateLabel: UILabel!
    
    @IBOutlet private var chartView: MacawChartView!
    
    // MARK: - Data Model
    var realmServices: RealmServices!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.contentMode = .scaleAspectFit
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MacawChartView.playAnimations()
    }
    
    // MARK: - Actions
    @IBAction func previousDateButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func followingDateButtonTapped(_ sender: Any) {
        
    }
}

enum ChartsDisplayType {
    case week
    case month
    case year
}
