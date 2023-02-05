//
//  SuccessNewTripViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import Foundation

final class SuccessNewTripViewModel {

    private let trip: Trip

    init(trip: Trip) {
        self.trip = trip
    }
    
    var tripName: String? {
        trip.name
    }
    
    var tripImage: String? {
        trip.imageName
    }
    
    func getTrip() -> Trip {
        return trip
    }
}
