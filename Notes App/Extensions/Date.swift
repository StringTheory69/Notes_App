//
//  Date.swift
//  Notes App
//
//  Created by jason smellz on 10/24/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation

extension Date {
    /// Returns a string with a formatting of date dependent on distance from now
    var configureDateString: String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        
        guard let daysSinceNow = Calendar.current.dateComponents([.day], from: self, to: now).day else { return  formatter.string(from: Date()) }
        
        // if > one week display date
        formatter.dateFormat = "MM.dd.yy"
        guard daysSinceNow < 7 else {return formatter.string(from: self)}
        
        // if > yesterday but < week ago display day of the week
        guard daysSinceNow < 2 else {return formatter.weekdaySymbols[Calendar.current.component(.weekday, from: self)]}
        
        // if yesterday display yesterday
        guard daysSinceNow < 1 else {return "Yesterday"}
        
        // if today display time of day
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
}
