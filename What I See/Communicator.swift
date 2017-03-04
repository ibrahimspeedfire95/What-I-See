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
    
    class func performAsyncHTTPRequest(apiMethod: String, apiPath: String, parameters: Dictionary<String, Any>?, completion: ((_ isSuccess: Bool, _ day : [String: Any]?, String?) -> ())? = nil) {
        let fullURL = "https://gattaa-test.herokuapp.com/api/v1/\(apiMethod)"
        let request = AFJSONRequestSerializer().request(withMethod: apiMethod, urlString: fullURL, parameters: parameters, error: nil)
        request.timeoutInterval = 300.0
        request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1LCJ1c2VyX3Nlc3Npb25fZGF0dW1faWQiOjI2OX0.P3wp_o13zJ-AAYSLTY2fDRu491eBILb46CboscfLt2k", forHTTPHeaderField: "Authorization")
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer = AFJSONResponseSerializer()
        let task = manager.dataTask(with: request as URLRequest) { (response, responseObject, error) in
            if error == nil {
                completion!(true, responseObject as! [String : Any]?, nil)
            } else {
                completion!(false, nil, error?.localizedDescription)
            }
        }
        task.resume()
    }
}
