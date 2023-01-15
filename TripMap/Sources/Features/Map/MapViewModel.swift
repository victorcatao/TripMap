//
//  MapViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import Foundation
import CoreLocation
import CoreData

final class MapViewModel {
    
    // MARK: - Private Properties
    
    private(set) var pinObjects: [Pin] = []
    private let trip: Trip?
    private var filter: MapFilterViewModel.Filter? {
        didSet {
            loadPins()
        }
    }
    private var managedContext: NSManagedObjectContext = {
        DataManager.shared.context
    }()
    
    // MARK: - LifeCycle

    init(trip: Trip?) {
        self.trip = trip
        loadPins()
    }
    
    // MARK: - Private Methods
    
    private func loadPins() {
        var allPins: [Pin] = []
        
        defer {
            pinObjects = allPins
        }
        
        let request = Pin.fetchRequest()
        if let trip = trip {
            request.predicate = NSPredicate(format: "trip = %@", trip)
        }
        
        do {
            allPins = try managedContext.fetch(request)
        } catch let error {
            print("Error fetching songs \(error)")
        }

        guard let filter = filter else { return }
        
        if filter.showVisited == false {
            allPins.removeAll(where: { $0.visited == true })
        }
        
        if filter.showNotVisited == false {
            allPins.removeAll(where: { $0.visited == false })
        }
        
        if filter.pins.isEmpty == false {
            allPins.removeAll { fetchedPin in
                filter.pins.first { filteredPin in
                    fetchedPin.icon == filteredPin.emoji
                } == nil
            }
        }
    }
    
    // MARK: - Public Methods

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
    
    func createNewPinViewModel(coordinates: CLLocationCoordinate2D) -> NewPinViewModel {
        return NewPinViewModel(trip: trip, latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func createMapFilterViewModel() -> MapFilterViewModel {
        return MapFilterViewModel(filter: filter)
    }
    
    func setFilter(_ filter: MapFilterViewModel.Filter) {
        self.filter = filter
    }
}
