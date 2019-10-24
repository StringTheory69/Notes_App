//
//  Extensions.swift
//  Notes App
//
//  Created by jason smellz on 10/21/19.
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
        formatter.dateFormat = "HH:mm a"
        return formatter.string(from: self)
    }
}

extension String {
    
    // for use in note cell
    
    var truncateBody: String {
        
        let truncatePoint = 20
        
        // if new line exists truncate body after first new line
        guard self.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return self.components(separatedBy: "\n")[1]
        }
        
        // else truncate after first 30 characters
        guard self.count > truncatePoint else {return ""}
        
        // if there are no spaces
        guard self.rangeOfCharacter(from: CharacterSet.init(charactersIn: " ")) != nil else {
            return String(self.suffix(self.count - truncatePoint))
        }
        
        // find first space after taking suffix after thirty characters
        let firstSpaceAfterSuffix = self.suffix(self.count - truncatePoint).split(separator: " " )[0]
        // split components based on first occurence of word after first space found
        return self.components(separatedBy: firstSpaceAfterSuffix)[1]
    }
    
}

extension UIColor {
    
    // static constant stored properties, initialized lazily
    static let notesBackground = UIColor(netHex: 0x1D1E1F)
    static let notesCellBackground = UIColor(netHex: 0x242526)
    static let notesCellBorder = UIColor(netHex: 0x727374)
    static let notesRed = UIColor(netHex: 0xFE3B30)
    static let notesBlack = UIColor(netHex: 0x141415).withAlphaComponent(0.9)
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension UIFont {
    
    static let heading = UIFont.systemFont(ofSize: 30)
    static let cellHeading = UIFont.systemFont(ofSize: 21)
    static let cellBody = UIFont.systemFont(ofSize: 18, weight: .thin)
    static let cellDate = UIFont.systemFont(ofSize: 15, weight: .thin)
    
}

