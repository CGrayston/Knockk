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
        
        // Set up realmServices data model
        let realmServices = RealmServices()
        
        // Inject realmServices to HomePage
        let navController = self.viewControllers![0] as! UINavigationController
        let navVC = navController.topViewController as! HomePageTableViewController
        navVC.realmServices = realmServices
        
        // Inject realmServices in TimesheetViewController
        let timesheetNavigationVC = self.viewControllers![1] as! UINavigationController
        let timesheetVC = timesheetNavigationVC.topViewController as! TimesheetViewController
        timesheetVC.realmServices = realmServices
        
        // Inject realmServices in CalendarPageViewController
        let calendarPageNavigationVC = self.viewControllers![2] as! UINavigationController
        let calendarPageVC = calendarPageNavigationVC.topViewController as! CalendarPageViewController
        calendarPageVC.realmServices = realmServices
        
        // Set Up Tab Bar
        let tabBar = self.tabBar
        tabBar.barTintColor = Constants.Colors.vivintOrange
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.white
        
        
        // Set up tab items
        for i in 0 ..< self.tabBar.items!.count {
            
            switch i {
                
            case 0:

                tabBar.items?[i].title = "DIPS"
                let firstTab = self.tabBar.items![i] as UITabBarItem
                firstTab.image = UIImage(systemName: "dollarsign.circle")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                firstTab.selectedImage = UIImage(systemName: "dollarsign.circle.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                firstTab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
                
            case 1:
                
                tabBar.items?[i].title = "Timesheet"
                let timesheetTab = self.tabBar.items![i] as UITabBarItem
                timesheetTab.image = UIImage(systemName: "clock")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                timesheetTab.selectedImage = UIImage(systemName: "clock.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                timesheetTab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
                
            case 2:
                
                tabBar.items?[i].title = "Calendar"
                let calendarTab = self.tabBar.items![i] as UITabBarItem
                calendarTab.image = UIImage(systemName: "calendar.circle")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                calendarTab.selectedImage = UIImage(systemName: "calendar.circle.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                calendarTab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
                
            case 3:
                
                tabBar.items?[i].title = "Objections"
                let objectionsTab = self.tabBar.items![i] as UITabBarItem
                objectionsTab.image = UIImage(systemName: "pencil.circle")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                objectionsTab.selectedImage = UIImage(systemName: "pencil.circle.fill")!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                objectionsTab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
                
            default:
                break
            }
        }
    }
}
