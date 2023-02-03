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
        switch noteType {
        case .trip:
            if let note = note { // update note
                note.title = title
                note.text = text
            } else { // new note
                let note = Note(context: DataManager.shared.context)
                note.title = title
                note.text = text
                trip?.addToNote(note)
            }
        case .pin:
            if let note = note { // update note
                note.title = title
                note.text = text
            } else { // new note
                let note = Note(context: DataManager.shared.context)
                note.title = title
                note.text = text
                pin?.addToNote(note)
            }
        }
        
        DataManager.shared.save()
    }
    
    func getTitleAndText() -> (String?, String?) {
        return (note?.title, note?.text)
    }
    
}
