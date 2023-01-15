//
//  Pin+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var name: String?
    @NSManaged public var visited: Bool
    @NSManaged public var icon: String?
    @NSManaged public var pinDescription: String?
    @NSManaged public var note: Note?
    @NSManaged public var trip: Trip?

}

extension Pin : Identifiable {

}
