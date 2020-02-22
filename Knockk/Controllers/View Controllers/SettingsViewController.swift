//
//  SettingsViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/26/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var ACGoalTextField: UITextField!
    @IBOutlet weak var WCGoalTextField: UITextField!
    
    // MARK: - Data Model
    var realmServices: RealmServices!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSettingsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Helper Functions
    func updateSettingsView() {
        //        let predicate = NSPredicate(format: "uid = %@", realmServices.userUID)
        //        guard let userProfile = realmServices.userRealmResults?.filter(predicate).first else {
        //            print("Error: No user profile, there should be a user profile before getting to the settingsPage")
        //            return
        //        }
        guard let currentUser = realmServices.currentUser else {
            print("Error: No user logged in when creating settings page!")
            return
        }
        
        ACGoalTextField.text = "\(currentUser.acGoal)"
        WCGoalTextField.text = "\(currentUser.wcGoal)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Actions
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        // Save to realmServices
        guard let currentUser = realmServices.currentUser,
            let acGoal = ACGoalTextField.text,
            let wcGoal = WCGoalTextField.text else {
                return
        }
        
        let dict = ["acGoal": Int(acGoal), "wcGoal": Int(wcGoal)]
        realmServices.update(currentUser, with: dict)
        // Use this noti
        NotificationCenter.default.post(name: Constants.Notifications.selectedDateChangedNotification, object: nil)
    }
    
    @IBAction func LogOutButtonTapped(_ sender: Any) {
        // Log User Out
        let firebaseAuth = Auth.auth()
        do {
            // USer was logged out
            try firebaseAuth.signOut()
            
            // Go back to login screen
            let homePageVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController
            let view = UIView(frame: self.view.frame)
            view.backgroundColor = .orange
            self.view.addSubview(view)
            self.view.window?.rootViewController = homePageVC
            self.view.window?.makeKeyAndVisible()
        } catch let signOutError as NSError {
            // Error logging user out
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}
