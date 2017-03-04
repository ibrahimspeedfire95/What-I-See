//
//  UserModel.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    public var fullName: String?
    public var email: String?
    public var phoneNumber: String?
    public var birthdate: NSNumber?
    
    init?(json: [String: Any]) throws {
        guard let fullName = json["full_name"] as? String else {
            throw SerializationError.missing("full_name")
        }
        
        guard let email = json["email"] as? String else {
            throw SerializationError.missing("email")
        }
        
        guard let phoneNumber = json["phone_number"] as? String else {
            throw SerializationError.missing("phone_number")
        }

        guard let birthdate = json["birthdate"] as? NSNumber else {
            throw SerializationError.missing("birthdate")
        }

        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.birthdate = birthdate
    }
}
