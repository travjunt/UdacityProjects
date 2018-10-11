//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Travis McCormick on 10/27/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: - Constants
    struct Constants {
        static let authURL = "https://www.udacity.com/api/session"
        static let userDataURL = "https://www.udacity.com/api/users/"
        static let signUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: - JSONKeys
    struct JSONKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let account = "account"
        static let isRegistered = "registered"
        static let accountKey = "key"
        static let session = "session"
        static let sessionId = "id"
        static let userInfoDictionary = "user"
    }
}
