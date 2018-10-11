//
//  GCD.swift
//  On The Map
//
//  Created by Travis McCormick on 11/7/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

// MARK: - Preform UI Updates on Main
func preformUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
