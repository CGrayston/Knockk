//
//  RealmObjects.swift
//  Knockk
//
//  Created by Chris Grayston on 11/26/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation
import RealmSwift

class User : Object {
    @objc dynamic var uid = ""
   
    @objc dynamic var acGoal = 0
    @objc dynamic var wcGoal = 0
    
    @objc dynamic var dateCreated: Date? = nil
    
    override static func primaryKey() -> String? {
        // Primary key - Eventually should be date
        return "uid"
    }
    
    convenience init(uid: String, dateCreated: Date) {
        self.init()
        
        self.uid = uid
        self.dateCreated = dateCreated
        
    }
}

class DIPS: Object {
    // MARK: - Properties
    // Primary key
    @objc dynamic var employeePlusDate = ""
    
    // That day of the week. Can only be one per calendar day per user
    @objc dynamic var date = Date()
    
    // Values displayed on DIPS page
    @objc dynamic var doors = 0
    @objc dynamic var interactions = 0
    @objc dynamic var pitches = 0
    @objc dynamic var leads = 0
    @objc dynamic var comeBacks = 0
    @objc dynamic var appointments = 0
    @objc dynamic var lessons = 0
    @objc dynamic var acs = 0
    @objc dynamic var wcs = 0
    
    // If sum of DIPS == 0 and timeWorked == 0 this should be false
    @objc dynamic var isWorkDay = false
    
    // Seconds worked that day
    @objc dynamic var timeWorked = 0
    
    // Employee UID - Probably going to be created from Firebase Auth
    @objc dynamic var employeeUID = ""
    
    // MARK: - Meta
    // Set primary key - date
    // Only want one entry per calendar day
    override static func primaryKey() -> String? {
        return "employeePlusDate"
    }
    
    
    convenience init(employeeUID: String, date: Date) {
        self.init()
        self.employeeUID = employeeUID
        self.date = date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        
        self.employeePlusDate = employeeUID + "+" + dateString
        
        
    }
}

class Objection: Object {
    // MARK: - Properties
    @objc dynamic var title = ""
    @objc dynamic var body = ""
}

class Pitch: Object {
    // MARK: - Init
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    // MARK: - Properties
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    
    // MARK: - Meta
//    override class func primaryKey() -> String? {
//        return "name"
//    }
}
