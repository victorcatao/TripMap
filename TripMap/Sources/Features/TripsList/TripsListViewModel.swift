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
    
    private enum Section: Int {
        case notFinished, finished
        init(section: Int) {
            if section == 0 {
                self = .notFinished
            } else {
                self = .finished
            }
        }
    }
    
    private var notFinishedTrips: [Trip] = []
    private var finishedTrips: [Trip] = []
    private var managedContext: NSManagedObjectContext {
        DataManager.shared.context
    }

    // MARK: - Public Methods
    
    func viewWillAppear() {
        reloadTrips()
    }
    
    func deleteTrip(at index: Int, section: Int) {
        let trip = getTrip(for: index, section: section)
        DataManager.shared.context.delete(trip)
        DataManager.shared.save()
        reloadTrips()
    }
    
    func finishTrip(index: Int, section: Int) {
        let trip = getTrip(for: index, section: section)
        trip.finished = !trip.finished
        DataManager.shared.save()
        reloadTrips()
    }
    
    func getNumberOfSections() -> Int {
        if finishedTrips.isEmpty && notFinishedTrips.isEmpty {
            return 0
        }
        if finishedTrips.isEmpty {
            return 1
        }
        return 2
    }
    
    func getNumberOfRows(for section: Int) -> Int {
        let section = Section(section: section)
        
        switch section {
        case .notFinished:
            return notFinishedTrips.count
        case .finished:
            return finishedTrips.count
        }
    }
    
    func getTrip(for index: Int, section: Int) -> Trip {
        let section = Section(section: section)
        
        switch section {
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
        } catch let error {
            print("Error fetching singers \(error)")
        }
        fetchedTrips.forEach { trip in
            trip.finished ? finishedTrips.append(trip) : notFinishedTrips.append(trip)
        }
    }
    
}
