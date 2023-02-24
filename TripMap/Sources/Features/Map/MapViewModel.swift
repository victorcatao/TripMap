//
//  MapViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import Foundation
import CoreLocation
import CoreData

// MARK: - MapViewModelProtocol

protocol MapViewModelProtocol: AnyObject {
    var pinObjects: [Pin] { get }

    func updateStatus(for coordinate: CLLocationCoordinate2D)
    func deletePin(latitude: Double, longitude: Double)
    func getPinWith(latitude: Double, longitude: Double) -> Pin?
    func createNewPinViewModel(coordinates: CLLocationCoordinate2D) -> NewPinViewModel
    func createEditPinViewModel(coordinates: CLLocationCoordinate2D) -> NewPinViewModel
    func createMapFilterViewModel() -> MapFilterViewModel
    func setFilter(_ filter: MapFilterViewModel.Filter)
    func didCreateNewPin(_ pin: Pin)
}

// MARK: - MapViewModel

final class MapViewModel: MapViewModelProtocol {
    
    // MARK: - Private Properties
    
    private(set) var pinObjects: [Pin] = []
    private let trip: Trip?
    private var filter: MapFilterViewModel.Filter? {
        didSet {
            loadPins()
        }
    }
    
    // MARK: - LifeCycle

    init(trip: Trip?) {
        self.trip = trip
        loadPins()
    }
    
    // MARK: - Private Methods
    
    private func loadPins() {
        var allPins = DataManager.shared.getAllPins(trip: trip)

        defer {
            pinObjects = allPins
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
        DataManager.shared.updatePinStatus(at: (coordinate.latitude, coordinate.longitude))
    }
    
    func deletePin(latitude: Double, longitude: Double) {
        DataManager.shared.deletePin(latitude: latitude, longitude: longitude)
    }
    
    func getPinWith(latitude: Double, longitude: Double) -> Pin? {
        return DataManager.shared.getPinWith(latitude: latitude, longitude: longitude)
    }
    
    func createNewPinViewModel(coordinates: CLLocationCoordinate2D) -> NewPinViewModel {
        return NewPinViewModel(trip: trip, latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func createEditPinViewModel(coordinates: CLLocationCoordinate2D) -> NewPinViewModel {
        guard let pin = getPinWith(latitude: coordinates.latitude, longitude: coordinates.longitude) else {
            return createNewPinViewModel(coordinates: coordinates)
        }
        
        return NewPinViewModel(trip: trip, pinToEdit: pin, latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    func createMapFilterViewModel() -> MapFilterViewModel {
        return MapFilterViewModel(filter: filter)
    }
    
    func setFilter(_ filter: MapFilterViewModel.Filter) {
        self.filter = filter
    }
    
    func didCreateNewPin(_ pin: Pin) {
        pinObjects.append(pin)
    }
}
