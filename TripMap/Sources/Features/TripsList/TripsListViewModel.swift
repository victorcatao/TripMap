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
    
    private var managedContext: NSManagedObjectContext {
        DataManager.shared.context
    }
    
    // MARK: - Public Properties

    private(set) var trips: [Trip] = []
    
    // MARK: - Public Methods
    
    func viewWillAppear() {
        reloadTrips()
    }
    
    func deleteTrip(at index: Int) {
        let trip = trips[index]
        DataManager.shared.context.delete(trip)
        DataManager.shared.save()
        reloadTrips()
    }
    
    private func reloadTrips() {
        let requestTrips: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try managedContext.fetch(requestTrips)
        } catch let error {
            print("Error fetching singers \(error)")
        }
        trips = fetchedTrips.reversed()
    }
    
}
