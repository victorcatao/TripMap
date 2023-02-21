//
//  NoteViewModelTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 19/02/23.
//

import XCTest
import CoreLocation
@testable import TripMap

final class NoteViewModelTests: XCTestCase {
    
    private var sut: NoteViewModelProtocol!
    
    func test_titleAndText() {
        // Given
        let pin = Pin(context: DataManager.shared.context)
        pin.name = "Pin A"
        pin.pinDescription = "Desc Pin A"
        
        let note = Note(context: DataManager.shared.context)
        note.title = "Title"
        note.text = "Text"
        
        sut = NoteViewModel(pin: pin, note: note)
        
        // When
        let (title, text) = sut.getTitleAndText()

        // Then
        XCTAssertEqual(title, note.title)
        XCTAssertEqual(text, note.text)
    }
    
    func test_saveNote() {
        // Given
        let pin = Pin(context: DataManager.shared.context)
        pin.name = "Pin A"
        pin.pinDescription = "Desc Pin A"
        
        let note = Note(context: DataManager.shared.context)
        note.title = "Title"
        note.text = "Text"
        
        sut = NoteViewModel(pin: pin, note: nil)
        
        // When
        sut.saveNote(title: "Title", text: "text")

        // Then
        XCTAssertEqual(pin.notes!.count, 1)
    }
    
}
