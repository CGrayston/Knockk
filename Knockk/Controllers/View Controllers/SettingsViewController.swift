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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func LogOutButtonTapped(_ sender: Any) {
        // Log User Out
        let firebaseAuth = Auth.auth()
        do {
            // USer was logged out
            try firebaseAuth.signOut()
            
            // Go back to login screen
            let homePageVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController
            var view = UIView(frame: self.view.frame)
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
