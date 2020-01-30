//
//  SplashViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/28/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Set up views
        self.view.backgroundColor = .orange
        
        if Auth.auth().currentUser != nil {
            // User is signed in

            // Set tabBar as root view controller
            DispatchQueue.main.async {
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: "TabBarVC") as? TabBarViewController
                //let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
            }
        } else {
            // No user is signed in.
            
            // Set login screen as root view controller
            DispatchQueue.main.async {
                let homePageVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") as? LoginViewController
                
                self.view.window?.rootViewController = homePageVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    } 
}


