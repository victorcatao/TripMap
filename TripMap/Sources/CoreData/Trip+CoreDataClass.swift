//
//  Trip+CoreDataClass.swift
//  TripMap
//
//  Created by Victor Catão on 05/02/23.
//
//

import Foundation
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
