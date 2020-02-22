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
import RealmSwift

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        
        // Set the presenting view controller of the GIDSignIn object
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance().signIn()
        
        
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
        // Check for error
        if let error = error {
            // Print out error and return
            print("Failed to sign in with error: ", error)
            return
        }
        
        // Get good auth credential
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Sign in
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Failed to sign in with error: ", error)
                return
            }
            // User is signed in
            
            // Write to Realm
            // Get realm object and userUID
            guard let userUID = Auth.auth().currentUser?.uid else {
                fatalError("no userUID, will have to redo this unwrapping")
                //return
            }
            
            // Get the default Realm
            let realm = try! Realm()
            
            // Initilize our custom realm
            //let realmServices = RealmServices()
            
            // Query for user information
            let user = realm.objects(User.self).filter("uid == '\(userUID)'").first
            
            // Check if user exists
            if user == nil {
                // No user found - Create user
                let newUser = User(uid: userUID, dateCreated: Date())
                try! realm.write {
                    realm.add(newUser)
                }
            } else {
                // User found
                
                // TODO - Don't think anything needs to be done
                
            }
            
            // Otherwise update user
            
            
            // Segue logged in user to TabBar
            DispatchQueue.main.async {
                // TODO look at children see if we can init realm here
                let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC")
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
                
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        //Auth.auth().removeStateDidChangeListener(handle)
        print("sign out")
    }
    
    
}
