//
//  Pin+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 03/02/23.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var icon: String?
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var name: String?
    @NSManaged public var pinDescription: String?
    @NSManaged public var visited: Bool
    @NSManaged public var notes: NSSet?
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for notes
extension Pin {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

extension Pin : Identifiable {

}
