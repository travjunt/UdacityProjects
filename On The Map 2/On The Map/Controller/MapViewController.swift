//
//  MapViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 10/24/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: - MapViewController
class MapViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        DispatchQueue.main.async {
            ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
                if let studentLocations = studentLocations {
                    StudentInput.studentInputData = studentLocations as! [StudentInformation]
                    self.addAnnotations(StudentInput.studentInputData)
                
                    preformUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
            } else {
                Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyError)
                }
            }
        }
    }
    
    func removeAnnotations() {
        mapView.removeAnnotations(annotations)
        annotations.removeAll()
    }
    
    func addAnnotations(_ studentLocations: [StudentInformation]) {
        removeAnnotations()
        
        for studentLocation in StudentInput.studentInputData {
            let latitude = CLLocationDegrees(studentLocation.Latitude!)
            let longitude = CLLocationDegrees(studentLocation.Longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let firstName = studentLocation.FirstName!
            let lastName = studentLocation.LastName!
            let mediaURL = studentLocation.MediaURL!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = firstName + " " + lastName
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
		
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
            pinView!.calloutOffset = CGPoint(x: -5, y: 5)
			pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
			pinView!.annotation = annotation
        }
        return pinView
    }
	
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let app = UIApplication.shared
            
            if let url = URL(string: (view.annotation?.subtitle!)!), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            
            } else {
                Alert.pushAlert(controller: self, message: Alert.AlertMessages.invalidURL)
            }
        }
    }
}
