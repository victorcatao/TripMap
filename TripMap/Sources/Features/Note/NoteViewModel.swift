//
//  NoteViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 06/01/23.
//

import Foundation

final class NoteViewModel {
    
    // MARK: - Private Properties

    private enum NoteType {
        case trip, pin
    }
    
    private let trip: Trip?
    private let pin: Pin?
    private var noteType: NoteType {
        return trip == nil ? .pin : .trip
    }
    
    // MARK: - LifeCycle

    init(trip: Trip) {
        self.trip = trip
        self.pin = nil
    }
    
    init(pin: Pin) {
        self.pin = pin
        self.trip = nil
    }
    
    // MARK: - Public Methods

    func saveNote(title: String, text: String) {
        let note = Note(context: DataManager.shared.context)
        note.title = title
        note.text = text

        switch noteType {
        case .trip:
            trip?.note = note
        case .pin:
            pin?.note = note
        }
        
        DataManager.shared.save()
    }
    
    func getTitleAndText() -> (String?, String) {
        switch noteType {
        case .trip:
            return (trip?.note?.title, trip?.note?.text ?? "")
        case .pin:
            return (pin?.note?.title, pin?.note?.text ?? "")
        }
    }
    
}
