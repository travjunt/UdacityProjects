//
//  ParseClient.swift
//  On The Map
//
//  Created by Travis McCormick on 10/31/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

// MARK: - Parse Client
class ParseClient: NSObject {
    
    var session = URLSession.shared
    
    var objectID: String? = nil
    var mediaURL: String? = nil
    var mapString: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
	
    // MARK: - GET Method
    func taskForParseGETMethod(_ url: String, completionHandlerForParseGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-ID")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForParseGET(nil, NSError(domain: "taskForParseGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with the request: \(String(describing: error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let httpError = (response as? HTTPURLResponse)?.statusCode
                sendError("The request returned a status code: \(String(describing: httpError))")
                return
            }
            guard let data = data else {
                sendError("The request returned no data")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParseGET)
        }
        task.resume()
        return task
    }
    
    // MARK: - POST Method
    func taskForParsePOSTMethod(_ url: String, jsonBody: String, completionHandlerForParsePOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-ID")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForParsePOST(nil, NSError(domain: "taskForParsePOSTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Unable to post location")
                return
            }
            guard let data = data else {
                sendError("The request returned no data")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParsePOST)
        }
        task.resume()
        return task
    }
    
    // MARK: - PUT Method
    func taskForParsePUTMethod(_ url: String, jsonBody: String, completionHandlerForParsePUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PUT"
        request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-ID")
        request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForParsePUT(nil, NSError(domain: "taskForParsePUTMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError((error?.localizedDescription)!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Unable to update location")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParsePUT)
        }
        task.resume()
        return task
    }
	
	class func sharedInstance() -> ParseClient {
		struct Singleton {
			static var sharedInstance = ParseClient()
		}
		return Singleton.sharedInstance
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
    
}
