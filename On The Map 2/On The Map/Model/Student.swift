//
//  Student.swift
//  On The Map
//
//  Created by Travis McCormick on 10/31/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

// MARK: - Student Information Struct
struct StudentInformation {
    
    // MARK: - Constant Properties
    var FirstName: String?
    var LastName: String?
    var Latitude: Double?
    var Longitude: Double?
    var MediaURL: String?

    // MARK: - Initialize Student Dictionary
    init(dictionary: [String: AnyObject]) {
        
        if let firstName = dictionary[ParseClient.JSONKeys.firstName] as? String, firstName.isEmpty == false {
            FirstName = firstName
        } else {
            FirstName = ""
        }
        
        if let lastName = dictionary[ParseClient.JSONKeys.lastName] as? String, lastName.isEmpty == false {
            LastName = lastName
        } else {
            LastName = ""
        }
        
        if let latitude = dictionary[ParseClient.JSONKeys.latitude] as? Double, latitude.isNaN == false {
            Latitude = latitude
        } else {
            Latitude = 0.0
        }
        
        if let longitude = dictionary[ParseClient.JSONKeys.longitude] as? Double, longitude.isNaN == false {
            Longitude = longitude
        } else {
            Longitude = 0.0
        }
        
        if let mediaURL = dictionary[ParseClient.JSONKeys.mediaURL] as? String, mediaURL.isEmpty == false {
            MediaURL = mediaURL
        } else {
            MediaURL = ""
        }
    }
}
