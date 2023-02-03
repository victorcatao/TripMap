//
//  Pin+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 29/01/23.
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
    @NSManaged public var note: NSSet?
    @NSManaged public var trip: Trip?

}

// MARK: Generated accessors for note
extension Pin {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

extension Pin : Identifiable {

}
