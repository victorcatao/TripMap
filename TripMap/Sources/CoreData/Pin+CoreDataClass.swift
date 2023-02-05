//
//  Pin+CoreDataClass.swift
//  TripMap
//
//  Created by Victor Catão on 05/02/23.
//
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.creationDate = Date()
    }
}
