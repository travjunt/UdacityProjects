//
//  UdacityClient.swift
//  On The Map
//
//  Created by Travis McCormick on 10/23/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

// MARK: - UdacityClient
class UdacityClient: NSObject {
    
    var session = URLSession.shared
    
    var userID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
	
    // MARK: - GET Method
    func taskForUdacityGETMethod(_ url: String, completionHandlerForUdacityGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = URLRequest(url: URL(string: url)!)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUdacityGET(nil, NSError(domain: "taskForUdacityGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Unable to retrieve your Udacity Information")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForUdacityGET)
        }
        task.resume()
        return task
    }
    
    // MARK: - POST Method
    func taskForUdacityPOSTMethod(_ url: String, jsonBody: String, completionHandlerForUdacityPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUdacityPOST(nil, NSError(domain: "taskForUdacityPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("The email address or password are incorrect.")
                print("Udacity POST Method - statusCode was called: \(String(describing: response))")
                
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForUdacityPOST)
        }
        task.resume()
        return task
    }
    
    // MARK: - DELETE Method
    func taskForUdacityDELETEMethod(_ url: String, completionHandlerForUdacityDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
       
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForUdacityDELETE(nil, NSError(domain: "taskForUdacityDELETEMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Logout request failed")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            self.convertDataWithCompletionHandler(newData, completionHandlerForConvertData: completionHandlerForUdacityDELETE)
        }
        task.resume()
        return task
    }
	
	// Convert raw JSON into Object
	func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
		
		var parsedResult: AnyObject! = nil
		do {
			parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
			completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		completionHandlerForConvertData(parsedResult, nil)
	}
	
	// Shared Instance
	class func sharedInstance() -> UdacityClient {
		struct Singleton {
			static var sharedInstance = UdacityClient()
		}
		return Singleton.sharedInstance
	}
}
