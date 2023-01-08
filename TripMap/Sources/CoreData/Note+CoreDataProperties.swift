//
//  Note+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 08/01/23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var text: String?

}

extension Note : Identifiable {

}
