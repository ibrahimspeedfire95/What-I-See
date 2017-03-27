//
//  UserOperator.swift
//  What I See
//
//  Created by ibrahim al-khatib on 2/18/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class UserOperator {

    class func login(email: String, password: String, success: @escaping (UserModel) -> (), failure: @escaping (String) -> ()) {
        
        let params = ["email" : email,
                      "password" : password]
        
        Communicator.performAsyncHTTPRequest(apiMethod: .post, api: "user_sessions", parameters: params, success: { (responseObject) in
            do {
                let json = responseObject as! [String : Any]

                let user = try UserModel(json: json["user"] as! [String : Any])
                success(user)
            } catch {
                failure(error.localizedDescription)
            }
        }) { (errorMessage) in
            failure(errorMessage)
        }
    }
    
//    class func signUp(email: String, password: String, completion: ((Bool, UserModel?, String?) -> ())? = nil) {
    
}
