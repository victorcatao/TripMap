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
        DataManager.shared.createPin(
            name: "Pin A",
            description: "Desc Pin A",
            emoji: "🏕",
            trip: nil,
            coordinate: (10, 10)
        ) { _, pinA in
            guard let pin = pinA else {
                XCTFail("Couldn't create the Pin")
                return
            }
            
            defer {
                DataManager.shared.deletePin(latitude: 10, longitude: 10)
            }
            
            let note = DataManager.shared.createNote(pin: pin, title: "Title", text: "text")
            
            self.sut = NoteViewModel(pin: pin, note: note)
            
            let (title, text) = self.sut.getTitleAndText()
            
            XCTAssertEqual(title, note.title)
            XCTAssertEqual(text, note.text)
        }
    }
    
    func test_saveNote() {
        DataManager.shared.createPin(
            name: "Pin A",
            description: "Desc Pin A",
            emoji: "🏕",
            trip: nil,
            coordinate: (10, 10)
        ) { _, pinA in
            guard let pin = pinA else {
                XCTFail("Couldn't create the Pin")
                return
            }
            
            defer {
                DataManager.shared.deletePin(latitude: 10, longitude: 10)
            }
            
            let note = DataManager.shared.createNote(pin: pin, title: "Title", text: "text")
            self.sut = NoteViewModel(pin: pin, note: note)
            self.sut.saveNote(title: "Title", text: "Text")
            
            XCTAssertEqual(pin.notes!.count, 1)
        }
    }
    
}
