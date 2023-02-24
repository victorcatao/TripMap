//
//  DataManagerTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 23/02/23.
//

import XCTest
import CoreLocation
import CoreData
@testable import TripMap

final class DataManagerTests: XCTestCase {
    
    private let sut = DataManager.shared
    private var tripHelper: Trip!
    private var pinHelper: Pin!
    private var noteHelper: Note!
    
    override func setUp() {
        super.setUp()
        
        // Create a trip to use on tests
        sut.createTrip(name: "Test Trip", image: "anyImage") { trip in
            self.tripHelper = trip!
            
            // Create a pin to use on tests
            self.sut.createPin(name: "Test Pin", description: "Desc", emoji: "🏖", trip: self.tripHelper, coordinate: (latitude: 10, longitude: 10)) { error, pin in
                self.pinHelper = pin!
            }
            
            self.noteHelper = self.sut.createNote(trip: self.tripHelper, title: "Test", text: "text")
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut.deleteTrip(tripHelper)
    }
    
    // MARK: - Trips
    
    func test_createTrip() {
        sut.createTrip(name: "Test \(#function)", image: "anyImage") { trip in
            if let trip {
                self.sut.deleteTrip(trip)
            } else {
                XCTFail("Trip not created")
            }
        }
    }
    
    func test_getTrip() {
        XCTAssertNotNil(self.sut.getTrip(objectID: tripHelper.objectID))
    }
    
    func test_getAllTrips() {
        XCTAssertTrue(sut.getAllTrips().count > 0)
    }
    
    func test_updateTripName() {
        sut.updateTripName(trip: tripHelper, name: "abc")
        XCTAssertEqual(tripHelper.name, "abc")
    }
    
    func test_deleteTrip() {
        let id = tripHelper.objectID
        sut.deleteTrip(tripHelper)
        XCTAssertNil(sut.getTrip(objectID: id))
    }
    
    func test_finishTrip() {
        let finished = tripHelper.finished
        sut.finishTrip(tripHelper)
        XCTAssertEqual(tripHelper.finished, !finished)
    }
    
    // MARK: - Pins
    
    func test_getPin() {
        XCTAssertNotNil(sut.getPin(objectID: pinHelper.objectID))
    }
    
    func test_createPin() {
        sut.createPin(name: "Test Pin", description: "Desc", emoji: "🏖", trip: self.tripHelper, coordinate: (latitude: 10, longitude: 10)) { error, pin in
            defer {
                self.sut.deletePin(latitude: pin!.lat, longitude: pin!.lng)
            }
            XCTAssertNotNil(pin)
        }
    }
    
    func test_updatePin() {
        let expectedName = "New name"
        let expectedDescription = "New description"
        let expectedIcon = "🏕"
        
        sut.updatePin(pinHelper, name: expectedName, description: expectedDescription, icon: expectedIcon)
        
        XCTAssertEqual(pinHelper.name, expectedName)
        XCTAssertEqual(pinHelper.pinDescription, expectedDescription)
        XCTAssertEqual(pinHelper.icon, expectedIcon)
    }
    
    func test_getAllPins() {
        XCTAssertTrue(sut.getAllPins().count > 0)
        XCTAssertTrue(sut.getAllPins(trip: tripHelper).count > 0)
    }
    
    func test_updatePinStatus() {
        let expectedStatus = !pinHelper.visited
        sut.updatePinStatus(at: (latitude: pinHelper.lat, longitude: pinHelper.lng))
        
        XCTAssertEqual(pinHelper.visited, expectedStatus)
    }
    
    func test_deletePin() {
        let pinObjectID = pinHelper.objectID
        
        sut.deletePin(latitude: pinHelper.lat, longitude: pinHelper.lng)
        
        XCTAssertNil(sut.getPin(objectID: pinObjectID))
    }
    
    func test_getPinWith() {
        XCTAssertNotNil(sut.getPinWith(latitude: pinHelper.lat, longitude: pinHelper.lng))
    }
    
    // MARK: - Notes
    
    func test_createNote() {
        let notePin = sut.createNote(pin: pinHelper, title: "Test", text: "text")
        let noteTrip = sut.createNote(trip: tripHelper, title: "Test", text: "text")
        
        defer {
            sut.deleteNote(note: notePin)
            sut.deleteNote(note: noteTrip)
        }
        
        XCTAssertNotNil(notePin)
        XCTAssertNotNil(noteTrip)
    }
    
    func test_updateNote() {
        let expectedTitle = "Expected title"
        let expectedText = "Expected text"
        
        sut.updateNote(note: noteHelper, title: expectedTitle, text: expectedText)
    }
    
    func test_deleteNote() {
        sut.deleteNote(note: noteHelper)
    }
    
}
