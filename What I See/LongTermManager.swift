//
//  LongTermManager.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/4/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class LongTermManager: NSObject {
    
    class var currentUser: UserModel? {
        set {
            UserDefaults.standard.set(newValue?.toDictionary(), forKey: "currentUser")
        }
        get {
            if let dictionary = UserDefaults.standard.value(forKey: "currentUser") as? [String : Any] {
                let currentUser = try? UserModel(json: dictionary)
                return currentUser!
            } else {
                return nil
            }
        }
    }
    
    class var currentAuthToken: String {
        set {
            UserDefaults.standard.set(newValue, forKey: "currentAuthToken")
        }
        get {
            let currentAuthToken = UserDefaults.standard.value(forKey: "currentAuthToken") as? String
            return currentAuthToken ?? ""
        }
    }
    
}
