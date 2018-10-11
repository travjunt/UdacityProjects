//
//  TextFieldDelegate.swift
//  On The Map
//
//  Created by Travis McCormick on 11/14/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit

// MARK: - TextFieldDelegate
class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
