//
//  NoteViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 06/01/23.
//

import Foundation

final class NoteViewModel {
    
    private let trip: Trip?
    private let pin: Pin?
    
    init(trip: Trip?) {
        self.trip = trip
        self.pin = nil
    }
    
    init(pin: Pin?) {
        self.pin = pin
        self.trip = nil
    }
    
}
