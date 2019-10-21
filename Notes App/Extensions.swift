//
//  Extensions.swift
//  Notes App
//
//  Created by jason smellz on 10/21/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation

extension Date {
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
}
