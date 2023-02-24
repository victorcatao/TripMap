//
//  NotesListViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 29/01/23.
//

import Foundation

final class NotesListViewModel {

    // MARK: - Private Properties

    private enum NoteType {
        case trip, pin
    }
    
    private var trip: Trip?
    private var pin: Pin?
    private var notes: [Note]
    private var noteType: NoteType {
        return trip == nil ? .pin : .trip
    }
    
    // MARK: - LifeCycle

    init(trip: Trip) {
        self.trip = trip
        self.pin = nil
        self.notes = trip.notes?.allObjects as? [Note] ?? []
        sortNotes()
    }
    
    init(pin: Pin) {
        self.pin = pin
        self.trip = nil
        self.notes = pin.notes?.allObjects as? [Note] ?? []
    }
    
    // MARK: - Public Methods

    func getNumberOfRows() -> Int {
        return notes.count
    }
    
    func getNote(at index: Int) -> Note? {
        return notes[index]
    }
    
    func reloadData() {
        switch noteType {
        case .pin:
            guard let objectId = pin?.objectID else { return }
            pin = DataManager.shared.getPin(objectID: objectId)
            notes = (pin?.notes?.allObjects as? [Note])?.filter({$0.title != nil}) ?? []
            sortNotes()
        case .trip:
            guard let objectId = trip?.objectID else { return }
            trip = DataManager.shared.getTrip(objectID: objectId)
            notes = (trip?.notes?.allObjects as? [Note])?.filter({$0.title != nil}) ?? []
            sortNotes()
        }
    }
    
    func getViewControllerTitle() -> String? {
        switch noteType {
        case .trip:
            return trip?.name
        case .pin:
            return pin?.name
        }
    }
    
    func createViewControllerForNewNote() -> NoteViewController? {
        switch noteType {
        case .trip:
            guard let trip = trip else { return nil }
            return NoteViewController(viewModel: NoteViewModel(trip: trip, note: nil))
        case .pin:
            guard let pin = pin else { return nil }
            return NoteViewController(viewModel: NoteViewModel(pin: pin, note: nil))
        }
    }
    
    func createViewControllerForNote(at index: Int) -> NoteViewController? {
        guard let note = getNote(at: index) else { return nil }
        
        switch noteType {
        case .trip:
            guard let trip = trip else { return nil }
            return NoteViewController(viewModel: NoteViewModel(trip: trip, note: note))
        case .pin:
            guard let pin = pin else { return nil }
            return NoteViewController(viewModel: NoteViewModel(pin: pin, note: note))
        }
    }
    
    func deleteNote(at index: Int) {
        guard let note = getNote(at: index) else { return }
        DataManager.shared.deleteNote(note: note)
        reloadData()
    }
    
    // MARK: - Private Methods

    private func sortNotes() {
        notes.sort(by: { $0.creationDate ?? Date() > $1.creationDate ?? Date() })
    }
    
}
