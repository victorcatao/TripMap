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
    private var filteredNotFinishedTrips: [Trip] = []
    private var filteredFinishedTrips: [Trip] = []
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
    
    func getNumberOfRows() -> Int {
        switch currentSelection {
        case .notFinished:
            return filteredNotFinishedTrips.count
        case .finished:
            return filteredFinishedTrips.count
        }
    }
    
    func getTrip(at index: Int) -> Trip {
        switch currentSelection {
        case .notFinished:
            return filteredNotFinishedTrips[index]
        case .finished:
            return filteredFinishedTrips[index]
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

        filteredNotFinishedTrips = notFinishedTrips
        filteredFinishedTrips = finishedTrips
    }
    
    func updateSelection(_ selection: Selection) {
        currentSelection = selection
    }
    
    func setFilteredText(_ text: String) {
        guard text.isEmpty == false else {
            filteredNotFinishedTrips = notFinishedTrips
            filteredFinishedTrips = finishedTrips
            return
        }

        switch currentSelection {
        case .finished:
            filteredFinishedTrips = finishedTrips.filter({
                $0.name?.localizedCaseInsensitiveContains(text) ?? false
            })
        case .notFinished:
            filteredNotFinishedTrips = notFinishedTrips.filter({
                $0.name?.localizedCaseInsensitiveContains(text) ?? false
            })
        }
    }
    
    func updateTripName(_ name: String, at index: Int) {
        let trip = getTrip(at: index)
        trip.name = name
   
        do {
            try DataManager.shared.context.save()
        } catch(_) {
            
        }
    }
    
}
