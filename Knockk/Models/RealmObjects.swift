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
    @objc dynamic var name : String? = nil
    var age = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
        // Primary key - Eventually should be date
        return "name"
    }
}

class DIPS: Object {
    // MARK: - Properties
    // Primary key
    @objc dynamic var employeePlusDate = ""
    
    // That day of the week. Can only be one per calendar day per user
    @objc dynamic var date : Date? = nil
    
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

extension User {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .modified)
        }
    }
}

extension DIPS {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .modified)
        }
    }
}
