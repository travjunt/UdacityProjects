//
//  LoginViewController.swift
//  On The Map
//
//  Created by Travis McCormick on 10/20/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import UIKit

// MARK: - LoginViewController
class LoginViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: RoundButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
    }
    
    // MARK: - Sign Up Button Pressed
    @IBAction func signUpButton(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: UdacityClient.Constants.signUpURL)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Complete Login
    private func completeLogin() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "MapNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Login Button Pressed
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            Alert.pushAlert(controller: self, message: Alert.AlertMessages.emptyCredentials)
        } else {
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            UdacityClient.sharedInstance().postSession(username: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                
                if let error = error {
                    Alert.pushAlert(controller: self, message: error.localizedDescription)
                    
                    preformUIUpdatesOnMain {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                    }
                } else {
                    if let userID = result?[UdacityClient.JSONKeys.accountKey] as? String {
                        
                        UdacityClient.sharedInstance().userID = userID
                        preformUIUpdatesOnMain {
                            self.activityIndicator.stopAnimating()
                            self.completeLogin()
                        }
                    }
                }
            }
        }
    }
}
