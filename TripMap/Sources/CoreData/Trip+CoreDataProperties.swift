//
//  Trip+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 05/02/23.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var finished: Bool
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var notes: NSSet?
    @NSManaged public var pins: NSSet?

}

// MARK: Generated accessors for notes
extension Trip {

    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)

    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)

    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)

    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)

}

// MARK: Generated accessors for pins
extension Trip {

    @objc(addPinsObject:)
    @NSManaged public func addToPins(_ value: Pin)

    @objc(removePinsObject:)
    @NSManaged public func removeFromPins(_ value: Pin)

    @objc(addPins:)
    @NSManaged public func addToPins(_ values: NSSet)

    @objc(removePins:)
    @NSManaged public func removeFromPins(_ values: NSSet)

}

extension Trip : Identifiable {

}
