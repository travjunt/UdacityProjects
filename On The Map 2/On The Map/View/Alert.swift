//
//  Alert.swift
//  On The Map
//
//  Created by Travis McCormick on 11/8/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Alert
class Alert {
    
    // pushAlert Method
    class func pushAlert(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "Something is wrong.", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        preformUIUpdatesOnMain {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

extension Alert {
    
    // AlertMessages
    struct AlertMessages {
        static let emptyCredentials = "Please enter email address and password."
        static let emptyError = "Unable to get student data."
        static let emptyLocation = "Please enter a location."
        static let emptyPlacemark = "Placemark not found."
        static let emptyURL = "Please enter a URL."
        static let invalidURL = "Invalid URL."
        static let failedLogout = "Logout request failed."
        static let duplicateLocation = "Student location already posted."
    }
}
