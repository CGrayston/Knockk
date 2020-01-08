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

extension User {
    func writeToRealm() {
        try! uiRealm.write {
            uiRealm.add(self, update: .modified)
        }
    }
}
