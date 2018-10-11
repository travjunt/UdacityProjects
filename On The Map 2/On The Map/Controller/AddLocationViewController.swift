//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 11/14/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - AddLocationViewController
class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    lazy var geocoder = CLGeocoder()
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
       locationTextField.delegate = textFieldDelegate
       websiteTextField.delegate = textFieldDelegate
    }
	
	@IBAction func websiteTextFieldTapped(_ sender: Any) {
		if websiteTextField.text?.isEmpty == true {
			websiteTextField.text = "https://"
		}
	}
	
    // MARK: - Find Location Button Pressed
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        if locationTextField.text?.isEmpty == false {
            self.activityIndicator.isHidden = false
            self.activityIndicator.stopAnimating()
            
            geocoder.geocodeAddressString(locationTextField.text!) { (placemarks, error) in
                
                if let error = error {
                    Alert.pushAlert(controller: self, message: error.localizedDescription)
                    
                    preformUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                } else {
                    if let placemark = placemarks?.first {
                        
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController
                        
                        controller.placemark = placemark
                        
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
            }
        } else {
            Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyLocation)
        }
        
        if websiteTextField.text?.isEmpty == false {
            
            ParseClient.sharedInstance().mediaURL = websiteTextField.text
        } else {
            Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyURL)
        }
    }
}
