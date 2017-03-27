//
//  Communicator.swift
//  Gattaa
//
//  Created by ibrahim al-khatib on 2/14/17.
//  Copyright © 2017 Gattaa. All rights reserved.
//

import Foundation
import AFNetworking

class Communicator {
    
    static let baseUrl = "https://what-i-see.herokuapp.com/user_api/"
    
    class func performAsyncHTTPRequest(apiMethod: HTTPMethodType, api: String, parameters: [String : Any]?, success: @escaping (Any) -> (), failure: @escaping (String) -> ()) {
        
        let fullURL = baseUrl + api

        let request = AFJSONRequestSerializer().request(withMethod: apiMethod.rawValue, urlString: fullURL, parameters: parameters, error: nil)
        request.setValue(LongTermManager.currentAuthToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 300.0
        
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer = AFJSONResponseSerializer()
        
        let task = manager.dataTask(with: request as URLRequest) { (response, responseObject, error) in
            if error == nil {
                success(responseObject as Any)
            } else {
                let error = (responseObject as! [String : Any])["error"] as! String
                failure(error)
            }
        }
        task.resume()
        
    }
}
