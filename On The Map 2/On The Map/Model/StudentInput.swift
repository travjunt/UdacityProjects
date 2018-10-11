//
//  StudentInput.swift
//  On The Map
//
//  Created by Travis McCormick on 11/7/17.
//  Copyright © 2017 Travis McCormick. All rights reserved.
//

import Foundation

// MARK: - Student Input
class StudentInput {
    
    static var studentInputData = [StudentInformation]()
    
    static func studentDataFromResults(_ results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var studentData = [StudentInformation]()
        
        for result in results {
            studentData.append(StudentInformation(dictionary: result))
        }
        return studentData
    }
}
