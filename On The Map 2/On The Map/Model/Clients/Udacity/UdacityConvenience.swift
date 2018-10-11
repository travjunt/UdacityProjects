//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Travis McCormick on 11/7/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: - GET Convenience
    func getUserData(_ completionHandlerForUserData: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let url = Constants.userDataURL + userID!
        
        let _ = taskForUdacityGETMethod(url) { (result, error) in
            if let error = error {
                completionHandlerForUserData(nil, error)
            } else {
                if let result =  result?[JSONKeys.userInfoDictionary] as? [String: AnyObject] {
                    completionHandlerForUserData(result as AnyObject, nil)
                } else {
                    completionHandlerForUserData(nil, NSError(domain: "getUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getUserData"]))
                }
            }
        }
    }
    
    //MARK: - POST Convenience
    func postSession(username: String, password: String, completionHandlerForSession: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let url = Constants.authURL
        let jsonBody = "{\"\(JSONKeys.udacity)\": {\"\(JSONKeys.username)\": \"\(username)\", \"\(JSONKeys.password)\": \"\(password)\"}}"
        
        let _ = taskForUdacityPOSTMethod(url, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(nil, error)
            } else {
                if let result = result?[JSONKeys.account] as? [String: AnyObject] {
                    completionHandlerForSession(result as AnyObject, nil)
                } else {
                    completionHandlerForSession(nil, NSError(domain: "postSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postSession"]))
                }
            }
        }
    }
    
    //MARK: DELETE Convenience
    func deleteSession(_ completionHandlerForSession: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        let url = Constants.authURL
        
        let _ = taskForUdacityDELETEMethod(url) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(nil, error)
            } else {
                if let result = result?[JSONKeys.session] as? [String: AnyObject] {
                    completionHandlerForSession(result as AnyObject, nil)
                } else {
                    completionHandlerForSession(nil, NSError(domain: "deleteSession parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse deleteSession"]))
                }
            }
        }
    }
    
}
