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
    
    // MARK: - Private Properties
    
    private(set) var pinObjects: [Pin] = []
    private let trip: Trip

    private var managedContext: NSManagedObjectContext = {
        DataManager.shared.context
    }()
    
    // MARK: - LifeCycle

    init(trip: Trip) {
        self.trip = trip
        loadPins()
    }
    
    // MARK: - Private Methods
    
    private func loadPins() {
        let request = Pin.fetchRequest()
        request.predicate = NSPredicate(format: "trip = %@", trip)

        var fetchedSongs: [Pin] = []
        do {
            fetchedSongs = try managedContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }
        pinObjects = fetchedSongs
    }
    
    // MARK: - Public Methods

    func savePin(
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        let pin = Pin(context: managedContext)
        pin.name = name
        pin.lng = longitude
        pin.lat = latitude
        
        trip.addToPins(pin)
        
        do {
            try managedContext.save()
        } catch {
            
        }
        
        loadPins()
    }
    
    func updateStatus(for coordinate: CLLocationCoordinate2D) {
        let fetchRequest = Pin.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lng == %lf", coordinate.latitude, coordinate.longitude)
        
        do {
            let fetchResponse = try managedContext.fetch(fetchRequest)
            guard let pin = fetchResponse.first else { return }
            pin.setValue(!pin.visited, forKey: "visited")
            DataManager.shared.save()
        } catch {

        }
    }
    
    func deletePin(latitude: Double, longitude: Double) {
        guard let pin = getPinWith(latitude: latitude, longitude: longitude) else { return }
        managedContext.delete(pin)
        DataManager.shared.save()
    }
    
    func getPinWith(latitude: Double, longitude: Double) -> Pin? {
        let fetchRequest = Pin.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lat == %lf AND lng == %lf", latitude, longitude)
        
        do {
            let fetchResponse = try managedContext.fetch(fetchRequest)
            return fetchResponse.first
        } catch {
            return nil
        }
    }
}
