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
            return date.configureDateString
        }()
    
}
