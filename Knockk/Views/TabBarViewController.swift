//
//  TabBarViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/29/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.viewControllers)
        
        // Set up realmServices data model
        let realmServices = RealmServices()
        
        // Inject realmServices to HomePage
        let navController = self.viewControllers![0] as! UINavigationController
        let navVC = navController.topViewController as! HomePageTableViewController
        navVC.realmServices = realmServices
        
        // Inject realmServices in TimesheetViewController
        let timesheetVC = self.viewControllers![1] as! TimesheetViewController
        timesheetVC.realmServices = realmServices
        
        // Inject realmServices in CalendarPageViewController
        let calendarPageVC = self.viewControllers![2] as! CalendarPageViewController
        calendarPageVC.realmServices = realmServices
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
