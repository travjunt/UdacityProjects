//
//  TabBarViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 11/2/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import UIKit
import Foundation

class TabBarViewController: UITabBarController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession() { (result, error) in
            if error != nil {
                Alert.pushAlert(controller: self, message: Alert.AlertMessages.failedLogout)
            } else {
                if let sessionID = result?[UdacityClient.JSONKeys.sessionId] as? String, sessionID.isEmpty == false {
                    
                    preformUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {

        let mapViewController = self.viewControllers?[0] as! MapViewController
        let tableViewController = self.viewControllers?[1] as! TableViewController
        
        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            if let studentLocations = studentLocations {
                StudentInput.studentInputData = studentLocations as! [StudentInformation]
                
                preformUIUpdatesOnMain {
                    mapViewController.activityIndicator.isHidden = false
                    mapViewController.activityIndicator.startAnimating()
                    
                    mapViewController.addAnnotations(StudentInput.studentInputData)
                    tableViewController.loadView()
                    
                    mapViewController.activityIndicator.stopAnimating()
                    mapViewController.activityIndicator.isHidden = true
                }
            } else {
                Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyError)
            }
        }
    }
    
    @IBAction func addLocationButtonPressed(_ sender: Any) {
        if ParseClient.sharedInstance().objectID != nil {
            let alert = UIAlertController(title: "Overwrite location?", message: Alert.AlertMessages.duplicateLocation, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                self.navigationController?.pushViewController(controller, animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            preformUIUpdatesOnMain {
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
