//
//  TripsListViewModelTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 19/02/23.
//

import XCTest
import CoreLocation
@testable import TripMap

final class TripsListViewModelTests: XCTestCase {
    
    private var sut: TripsListViewModel!
    private let coordinateA = CLLocationCoordinate2DMake(20, 20)
    private let coordinateB = CLLocationCoordinate2DMake(30, 30)
    
    override func setUp() {
        super.setUp()
        
        sut = TripsListViewModel()
        
        sut.viewWillAppear() // load
        
        // It comes from local DB (CoreData). Sometimes it's empty, so we will need to add something there just to test purposes
        if sut.getNumberOfRows() == 0 {
            let trip = Trip(context: DataManager.shared.context)
            trip.name = "trip"
            
            let pinA = Pin(context: DataManager.shared.context)
            pinA.name = "Pin A"
            pinA.pinDescription = "Desc Pin A"
            pinA.visited = true
            pinA.lat = coordinateA.latitude
            pinA.lng = coordinateA.longitude
            
            let pinB = Pin(context: DataManager.shared.context)
            pinB.name = "Pin B"
            pinB.pinDescription = "Desc Pin B"
            pinB.visited = false
            pinB.lat = coordinateB.latitude
            pinB.lng = coordinateB.longitude
            
            trip.pins = NSSet(array: [pinA, pinB])
            
            try! DataManager.shared.context.save()
        }
    }
    
    func test_numberOfTrips() {
        XCTAssertTrue(sut.getNumberOfRows() > 0)
    }
    
    func test_updateTripName() {
        // Given
        let expectedName = "Test"

        // When
        sut.updateTripName(expectedName, at: 0)
        
        // Then
        XCTAssertEqual(sut.getTrip(at: 0).name, expectedName)
    }
    
    func test_setFilteredText() {
        // Given
        let search = "ThisIsAImprobableSearch"

        // When
        sut.setFilteredText(search)
        
        // Then
        XCTAssertEqual(sut.getNumberOfRows(), 0)
    }
    
}
