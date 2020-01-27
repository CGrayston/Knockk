//
//  LoginViewController.swift
//  Knockk
//
//  Created by Chris Grayston on 1/17/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        // Set the presenting view controller of the GIDSignIn object
        // (optionally) sign in silently when possible.
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            print("User is signed in")
            //GIDSignIn.sharedInstance().signIn()
            DispatchQueue.main.async {
                let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
                
            }
        } else {
            // No user is signed in.
            print("Not signed in")
        }
        
        
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

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("Failed to sign in with error: ", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to sign in with error: ", error)
                return
            }
            // User is signed in
            // TODO - Write to Realm
            
            // TODO * - Segue logged in user to HomePage
            //let homePageVC = self.storyboard?.instantiateViewController(identifier: "HomePageVC") as? HomePageTableViewController
            
            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBar")
            self.view.window?.rootViewController = tabBarVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}
