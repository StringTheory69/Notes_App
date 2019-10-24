//
//  Colors.swift
//  Notes App
//
//  Created by jason smellz on 10/17/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import UIKit

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
    
    static let heading = UIFont.systemFont(ofSize: 30) //UIFont(name: "Helvetica", size: 30)
    static let cellHeading = UIFont.systemFont(ofSize: 21) //UIFont(name: "Helvetica", size: 21)
    static let cellBody = UIFont.systemFont(ofSize: 18, weight: .thin) //UIFont(name: "Helvetica-Light", size: 18)
    static let cellDate = UIFont.systemFont(ofSize: 15, weight: .thin) //UIFont(name: "Helvetica-Light", size: 15)
}
