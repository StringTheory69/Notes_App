//
//  Note+CoreDataClass.swift
//  Notes App
//
//  Created by jason smellz on 10/23/19.
//  Copyright © 2019 jacob. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {

        lazy var dateString: String = {
            return convertDate(date: date)
        }()
    
        private func convertDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd.yy"
            return formatter.string(from: date)
        }
    
}
