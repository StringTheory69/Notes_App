//
//  Notes.swift
//  Notes App
//
//  Created by jason smellz on 10/18/19.
//  Copyright © 2019 jacob. All rights reserved.
//

import Foundation

struct Note {
    
    // date never changes - either now or previously stored date
    let date: Date!
    
    // dateString is lazy because it is not needed at init 
    lazy var dateString: String = {
        return convertDate(date: date)
    }()
    
    // text can be edited
    var body: String!
    
    lazy var truncationPoint = 30
    
    // for use in note cell
    lazy var truncatedTitle: String = {
        return String(body.prefix(truncationPoint))
    }()
    
    lazy var truncatedBody: String = {
        
        guard body.count > truncationPoint else {return ""}
        // find first space after taking suffix after thirty characters
        let firstSpaceAfterSuffix = body.suffix(body.count - truncationPoint).split(separator: " " )[0]
        // split components based on first occurence of word after first space found
        return body.components(separatedBy: firstSpaceAfterSuffix)[1]
    }()
    
    init(_ date: Date, _ body: String) {
        self.date = date
        self.body = body
    }
    
    private func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy"
        return formatter.string(from: date)
    }

}
