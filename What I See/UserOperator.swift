//
//  UserOperator.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class UserOperator {

    class func login(email: String, password: String, completion: ((Bool, UserModel?, String?) -> ())? = nil) {
        Communicator.performAsyncHTTPRequest(apiMethod: "", apiPath: "",  parameters: nil) { (success, responseObject, errorMessage) in
            if success {
                let user = try? UserModel(json: responseObject!)
                completion!(true, user!, "")
            } else {
                completion!(false, nil, errorMessage)
            }
        }
    }
    
}
