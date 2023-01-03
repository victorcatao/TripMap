//
//  TripsListViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit
import CoreData

final class TripsListViewModel {
    
    // MARK: - Private Properties

    private let spLat: Double = -23.5989
    private let spLng: Double = -46.6388
    
    private lazy var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Public Properties

    lazy var trips: [Trip] = {
        let requestTrips: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try managedContext.fetch(requestTrips)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        return fetchedTrips
    }()
    
    // MARK: - Public Methods

    func createData() {
        let pin = Pin(context: managedContext)
        pin.name = "Pin \(Int.random(in: 0..<100))"
        pin.lat = spLat
        pin.lng = spLng
        
        let trip = Trip(context: managedContext)
        trip.name = "Trip \(Int.random(in: 0..<100))"
        trip.pins = [pin]

        do {
            try managedContext.save()
        } catch {
            print("erro ao salvar")
        }
        
        
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        var fetchedSingers: [Pin] = []
        do {
            fetchedSingers = try managedContext.fetch(request)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        print("numberOfPins = \(fetchedSingers.count)")
        
        
        let requestTrips: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try managedContext.fetch(requestTrips)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        print("numberOfTrips = \(fetchedTrips.count)")
    }
    
}
