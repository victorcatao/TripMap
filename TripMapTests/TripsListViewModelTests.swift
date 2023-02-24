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
            DataManager.shared.createTrip(name: "Trip test", image: "") { trip in
                DataManager.shared.createPin(name: "Pin A", description: "Desc Pin A", emoji: "🏕", trip: trip!, coordinate: (self.coordinateA.latitude, self.coordinateA.longitude)) { _, _ in }
                DataManager.shared.createPin(name: "Pin B", description: "Desc Pin B", emoji: "🏡", trip: trip!, coordinate: (self.coordinateB.latitude, self.coordinateB.longitude)) { _, _ in }
            }
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
