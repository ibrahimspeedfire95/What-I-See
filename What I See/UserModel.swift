//
//  UserModel.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    public var id: NSNumber!
    public var email: String!
    public var firstName: String!
    public var lastName: String!
    public var birthdate: NSNumber!
    public var badgeCount: NSNumber!

    init(json: [String: Any]) throws {
        guard let id = json["id"] as? NSNumber else {
            throw SerializationError.missing("id")
        }
        
        guard let email = json["email"] as? String else {
            throw SerializationError.missing("email")
        }
        
        guard let firstName = json["first_name"] as? String else {
            throw SerializationError.missing("first_name")
        }

        guard let lastName = json["last_name"] as? String else {
            throw SerializationError.missing("Last_name")
        }
        
        guard let birthdate = json["birthdate"] as? NSNumber else {
            throw SerializationError.missing("birthdate")
        }

        guard let badgeCount = json["badge_count"] as? NSNumber else {
            throw SerializationError.missing("badge_count")
        }
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.badgeCount = badgeCount

    }
    
    public func toDictionary() -> [String : Any] {
        var dictionary = [String : Any]()
        dictionary["id"] = id
        dictionary["email"] = email
        dictionary["first_name"] = firstName
        dictionary["last_name"] = lastName
        dictionary["birthdate"] = birthdate
        dictionary["badge_count"] = badgeCount
        return dictionary
    }
}


