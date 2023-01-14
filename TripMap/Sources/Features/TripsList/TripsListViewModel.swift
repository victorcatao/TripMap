//
//  TripsListViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit
import CoreData

final class TripsListViewModel {
    
    // MARK: - Public Properties

    enum Selection: Int {
        case notFinished, finished
    }

    // MARK: - Private Properties
    
    
    
    private var notFinishedTrips: [Trip] = []
    private var finishedTrips: [Trip] = []
    private var currentSelection: Selection = .notFinished
    private var managedContext: NSManagedObjectContext {
        DataManager.shared.context
    }

    // MARK: - Public Methods
    
    func viewWillAppear() {
        reloadTrips()
    }
    
    func deleteTrip(at index: Int) {
        let trip = getTrip(at: index)
        DataManager.shared.context.delete(trip)
        DataManager.shared.save()
        reloadTrips()
    }
    
    func finishTrip(index: Int, section: Int) {
        let trip = getTrip(at: index)
        trip.finished = !trip.finished
        DataManager.shared.save()
        reloadTrips()
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        switch currentSelection {
        case .notFinished:
            return notFinishedTrips.count
        case .finished:
            return finishedTrips.count
        }
    }
    
    func getTrip(at index: Int) -> Trip {
        switch currentSelection {
        case .notFinished:
            return notFinishedTrips[index]
        case .finished:
            return finishedTrips[index]
        }
    }

    // MARK: - Private Methods
    
    private func reloadTrips() {
        finishedTrips = []
        notFinishedTrips = []
        
        let requestTrips: NSFetchRequest<Trip> = Trip.fetchRequest()
        var fetchedTrips: [Trip] = []
        do {
            fetchedTrips = try managedContext.fetch(requestTrips)
            fetchedTrips.reverse()
        } catch let error {
            print("Error fetching trips \(error)")
        }

        fetchedTrips.forEach { trip in
            trip.finished ? finishedTrips.append(trip): notFinishedTrips.append(trip)
        }
    }
    
    func updateSelection(_ selection: Selection) {
        currentSelection = selection
    }
    
}
