//
//  Button.swift
//  On The Map
//
//  Created by Travis McCormick on 11/14/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Round Button Class
@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
}
