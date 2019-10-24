//
//  Note+CoreDataProperties.swift
//  Notes App
//
//  Created by jason smellz on 10/23/19.
//  Copyright © 2019 jacob. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var body: String 
    @NSManaged public var date: Date
    @NSManaged public var id: UUID

}
