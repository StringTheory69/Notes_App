//
//  Extensions.swift
//  Notes App
//
//  Created by jason smellz on 10/21/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation

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

