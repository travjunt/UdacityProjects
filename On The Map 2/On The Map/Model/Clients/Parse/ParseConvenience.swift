//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Travis McCormick on 11/7/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: - GET Convenience
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        let url = Constants.studentLocationURL + "?" + QueryKeys.limit + "&" + QueryKeys.sortedByDate
        
        let _ = taskForParseGETMethod(url) { (results, error) in
            
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                if let results = results?[JSONKeys.StudentLocationsDictionary] as? [[String: AnyObject]] {
                    let studentInputData = StudentInput.studentDataFromResults(results)
                    completionHandlerForStudentLocations(studentInputData as AnyObject, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
                }
            }
        }
    }
    
    //MARK: - POST Convenience
    func postStudentLocation(accountKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForStudentLocations: @escaping (_ results: String?, _ error: NSError?) -> Void) {
        
        let url = Constants.studentLocationURL
        let jsonBody = "{\"\(JSONKeys.uniqueKey)\": \"\(accountKey)\", \"\(JSONKeys.firstName)\": \"\(firstName)\", \"\(JSONKeys.lastName)\": \"\(lastName)\",\"\(JSONKeys.mapString)\": \"\(mapString)\", \"\(JSONKeys.mediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.latitude)\": \(String(latitude)),\"\(JSONKeys.longitude)\": \(String(longitude))}"
        
        let _ = taskForParsePOSTMethod(url, jsonBody: jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                if let result = result?[JSONKeys.objectID] as? String {
                    self.objectID = result
                    completionHandlerForStudentLocations(result, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
                }
            }
        }
    }
    
    //MARK: - PUT Convenience
    func updateStudentLocation(accountKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completionHandlerForStudentLocations: @escaping (_ results: String?, _ error: NSError?) -> Void) {
        
        let url = Constants.studentLocationURL
        let jsonBody = "{\"\(JSONKeys.uniqueKey)\": \"\(accountKey)\",\"\(JSONKeys.firstName)\": \"\(firstName)\", \"\(JSONKeys.lastName)\": \"\(lastName)\",\"\(JSONKeys.mapString)\": \"\(mapString)\", \"\(JSONKeys.mediaURL)\": \"\(mediaURL)\",\"\(JSONKeys.latitude)\": \(String(latitude)),\"\(JSONKeys.longitude)\": \(String(longitude))}"
        
        let _ = taskForParsePUTMethod(url, jsonBody: jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForStudentLocations(nil, error)
            } else {
                if let result = result?[JSONKeys.updatedAt] as? String, result != "" {
                    completionHandlerForStudentLocations(result, nil)
                } else {
                    completionHandlerForStudentLocations(nil, NSError(domain: "updateStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse updateStudentLocation"]))
                }
            }
        }
    }
    
}
