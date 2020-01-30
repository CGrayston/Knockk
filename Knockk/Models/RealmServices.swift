//
//  RealmServices.swift
//  Knockk
//
//  Created by Chris Grayston on 1/27/20.
//  Copyright © 2020 Chris Grayston. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class RealmServices {
    // MARK: - Properties
    var dipsRealmResults: Results<DIPS>?
    var selectedDate: Date?
    var currentDIPS: DIPS?
    var userUID: String?
    
    var realm = try! Realm()

    // Source of truth
    //static let shared = RealmServices()
    
    // MARK: - Initializers
    init() {
        // Set Up Realm and query DIPS realm objects
        self.dipsRealmResults = realm.objects(DIPS.self)
        
        // Since ViewDidLoad - Get today's date
        self.selectedDate = Date()
        
        // Set userUID - Okay since this view is only accesible logged in
        self.userUID = Auth.auth().currentUser?.uid
        
    }
    
    
    
    // MARK: - CRUD Functions
    func create<T: Object>(with object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                // loop through dictionary call key - key, value - value
                for (key, value) in dictionary {
                    // perform all changes for dictionary
                    // Realm recomended way of doing this
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    // MARK: - Error Handling
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
}
