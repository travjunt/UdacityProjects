//
//  TableViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 11/2/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TableViewController
class TableViewController: UIViewController {
    
    @IBOutlet var locationsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        ParseClient.sharedInstance().getStudentLocations() { (studentLocations, error) in
            if let studentLocations = studentLocations {
                StudentInput.studentInputData = studentLocations as! [StudentInformation]
                preformUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                }
            } else {
                Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyError)
            }
        }
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInput.studentInputData.count
    }

    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "TableViewCell"
        let studentLocation = StudentInput.studentInputData[(indexPath as NSIndexPath).row]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: identifier)
        cell.imageView!.image = UIImage(named: "icon_pin")
        cell.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        cell.textLabel!.text = studentLocation.FirstName! + " " + studentLocation.LastName!
        cell.detailTextLabel?.text = studentLocation.MediaURL!
        
        return cell
    }
    
    // didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentInput.studentInputData[(indexPath as NSIndexPath).row]
        
        if let url = URL(string: (studentLocation.MediaURL)!) {
            UIApplication.shared.open(url, options: [:])
        } else {
            Alert.pushAlert(controller: self, message: Alert.AlertMessages.invalidURL)
        }
    }
}

