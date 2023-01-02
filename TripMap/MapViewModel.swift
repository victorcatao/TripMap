//
//  MapViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import Foundation
import MapKit
import CoreData

final class MapViewModel {
    
    private(set) var pinObjects: [MapPin] = []
    
    private lazy var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func savePin(
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Pin", in: managedContext)
        
        let pin = NSManagedObject(entity: entity!, insertInto: managedContext)
        pin.setValue(name, forKey: "name")
        pin.setValue(longitude, forKey: "lng")
        pin.setValue(latitude, forKey: "lat")
        pin.setValue(false, forKey: "visited")
        
        do {
            try managedContext.save()
            let pin = MapPin(
                lat: latitude,
                lng: longitude,
                name: name,
                visited: false
            )
            self.pinObjects.append(pin)
        } catch {
            print("opa nao salvou")
        }
    }
    
    func reloadData() {
        let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
        do {
            let results = try managedContext.fetch(fetchRequest)
            self.pinObjects = results.map {
                MapPin(
                    lat: $0.lat,
                    lng: $0.lng,
                    name: $0.name ?? "",
                    visited: $0.visited
                )
            }
        } catch {
            
        }
    }
    
    func updateStatus(for coordinate: CLLocationCoordinate2D) {
        let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lng == %lf", coordinate.latitude, coordinate.longitude)
        
        do {
            let fetchResponse = try managedContext.fetch(fetchRequest)
            guard let pin = fetchResponse.first else { return }
            pin.setValue(!pin.visited, forKey: "visited")
            try managedContext.save()
        } catch {

        }
    }
    
    func deletePin(latitude: Double, longitude: Double) {
        let fetchRequest: NSFetchRequest<Pin> = NSFetchRequest(entityName: "Pin")
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lng == %lf", latitude, longitude)
        
        do {
            let fetchResponse = try managedContext.fetch(fetchRequest)
            guard let pin = fetchResponse.first else { return }
            managedContext.delete(pin)
            try managedContext.save()
        } catch {

        }
    }
}

struct MapPin {
    let lat: Double
    let lng: Double
    let name: String
    let visited: Bool
}
