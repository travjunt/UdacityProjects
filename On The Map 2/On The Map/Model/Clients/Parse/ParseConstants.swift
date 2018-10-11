//
//  ParseConstants.swift
//  On The Map
//
//  Created by Travis McCormick on 10/31/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: - Parse Constants
    struct Constants {
        static let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation/"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    // MARK: - Query Keys
    struct QueryKeys {
        static let limit = "limit=100"
        static let sortedByDate = "order=-updatedAt"
    }
    
    // MARK: - JSON Keys
    struct JSONKeys {
        
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
        static let StudentLocationsDictionary = "results"
    }

}
