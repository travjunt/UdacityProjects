//
//  AddLocationMapViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 11/14/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: - AddLocationMapViewController
class AddLocationMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: RoundButton!
    
    var placemark: CLPlacemark? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if placemark != nil {
            let location = placemark?.location
            centerMapOnLocation(location!)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = (location?.coordinate)!
            annotation.title = placemark?.name!
            
            ParseClient.sharedInstance().mapString = placemark?.name
            ParseClient.sharedInstance().latitude = location?.coordinate.latitude
            ParseClient.sharedInstance().longitude = location?.coordinate.longitude
            
            self.mapView.addAnnotation(annotation)
        } else {
            Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyPlacemark)
        }
    }
    
    // MARK: - Finish Button Pressed
    @IBAction func finishButtonPressed(_ sender: Any) {
		
        UdacityClient.sharedInstance().getUserData() { (result, error) in
            
            if let error = error {
                Alert.pushAlert(controller: self, message: error.localizedDescription)
            } else {
                if let firstName = result?[UdacityClient.JSONKeys.firstName] as? String,
					let lastName = result?[UdacityClient.JSONKeys.lastName] as? String {
                    UdacityClient.sharedInstance().firstName = firstName
                    UdacityClient.sharedInstance().lastName = lastName
                    
                    if ParseClient.sharedInstance().objectID == nil {
						
                        ParseClient.sharedInstance().postStudentLocation(
							accountKey: UdacityClient.sharedInstance().userID!,
							firstName: firstName,
							lastName: lastName,
							mapString: ParseClient.sharedInstance().mapString!,
							mediaURL: ParseClient.sharedInstance().mediaURL!,
							latitude: ParseClient.sharedInstance().latitude!,
							longitude: ParseClient.sharedInstance().longitude!
						) { (result, error) in
                            
                            if let error = error {
                                Alert.pushAlert(controller: self, message: error.localizedDescription)
                            } else {
                                preformUIUpdatesOnMain {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    } else {
                        ParseClient.sharedInstance().updateStudentLocation(
							accountKey: UdacityClient.sharedInstance().userID!,
							firstName: firstName,
							lastName: lastName,
							mapString: ParseClient.sharedInstance().mapString!,
							mediaURL: ParseClient.sharedInstance().mediaURL!,
							latitude: ParseClient.sharedInstance().latitude!,
							longitude: ParseClient.sharedInstance().longitude!
						) { (result, error) in
                            
                            if let error = error {
                                Alert.pushAlert(controller: self, message: error.localizedDescription)
                            } else {
                                preformUIUpdatesOnMain {
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
	
	let regionRadius: CLLocationDistance = 500
	// CenterMapOnLocation
	func centerMapOnLocation (_ location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
		self.mapView.setRegion(coordinateRegion, animated: true)
	}
}

extension AddLocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
