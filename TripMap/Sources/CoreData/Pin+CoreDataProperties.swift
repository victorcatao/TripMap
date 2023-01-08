//
//  Pin+CoreDataProperties.swift
//  TripMap
//
//  Created by Victor Catão on 08/01/23.
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
    @NSManaged public var trip: Trip?
    @NSManaged public var note: Note?

}

extension Pin : Identifiable {

}
