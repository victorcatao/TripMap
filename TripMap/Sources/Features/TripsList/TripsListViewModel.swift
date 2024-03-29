//
//  TripsListViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit
import CoreData

// MARK: - TripsListSelection

enum TripsListSelection: Int {
    case notFinished, finished
}

// MARK: - TripsListViewModelProtocol

protocol TripsListViewModelProtocol: AnyObject {
    func viewWillAppear()
    func deleteTrip(at index: Int)
    func finishTrip(index: Int, section: Int)
    func getNumberOfRows() -> Int
    func getTrip(at index: Int) -> Trip
    func updateSelection(_ selection: TripsListSelection)
    func setFilteredText(_ text: String)
    func updateTripName(_ name: String, at index: Int)
}

// MARK: - TripsListViewModel

final class TripsListViewModel: TripsListViewModelProtocol {

    // MARK: - Private Properties
    
    private var notFinishedTrips: [Trip] = []
    private var finishedTrips: [Trip] = []
    private var filteredNotFinishedTrips: [Trip] = []
    private var filteredFinishedTrips: [Trip] = []
    private var currentSelection: TripsListSelection = .notFinished

    // MARK: - Public Methods
    
    func viewWillAppear() {
        reloadTrips()
    }
    
    func deleteTrip(at index: Int) {
        DataManager.shared.deleteTrip(getTrip(at: index))
        reloadTrips()
    }
    
    func finishTrip(index: Int, section: Int) {
        DataManager.shared.finishTrip(getTrip(at: index))
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
    
    func updateSelection(_ selection: TripsListSelection) {
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
        DataManager.shared.updateTripName(trip: trip, name: name)
    }

    // MARK: - Private Methods
    
    private func reloadTrips() {
        finishedTrips = []
        notFinishedTrips = []
        
        let fetchedTrips = DataManager.shared.getAllTrips().reversed()

        fetchedTrips.forEach { trip in
            trip.finished ? finishedTrips.append(trip): notFinishedTrips.append(trip)
        }

        filteredNotFinishedTrips = notFinishedTrips
        filteredFinishedTrips = finishedTrips
    }
    
}
