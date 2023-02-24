//
//  NoteViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 06/01/23.
//

import Foundation

// MARK: - NoteViewModelProtocol

protocol NoteViewModelProtocol: AnyObject {
    func saveNote(title: String, text: String)
    func getTitleAndText() -> (String?, String?)
}

// MARK: - NoteViewModel

final class NoteViewModel: NoteViewModelProtocol {
    
    // MARK: - Private Properties

    private enum NoteType {
        case trip, pin
    }
    
    private let trip: Trip?
    private let pin: Pin?
    private let note: Note?
    private var noteType: NoteType {
        return trip == nil ? .pin : .trip
    }
    
    // MARK: - LifeCycle

    init(trip: Trip, note: Note?) {
        self.trip = trip
        self.pin = nil
        self.note = note
    }
    
    init(pin: Pin, note: Note?) {
        self.pin = pin
        self.trip = nil
        self.note = note
    }
    
    // MARK: - Public Methods

    func saveNote(title: String, text: String) {
        if let note = note {
            DataManager.shared.updateNote(note: note, title: title, text: text)
        } else {
            switch noteType {
            case .trip:
                DataManager.shared.createNote(trip: trip, title: title, text: text)
            case .pin:
                DataManager.shared.createNote(pin: pin, title: title, text: text)
            }
        }
    }
    
    func getTitleAndText() -> (String?, String?) {
        return (note?.title, note?.text)
    }
    
}
