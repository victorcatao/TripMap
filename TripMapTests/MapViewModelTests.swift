//
//  MapViewModelTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 19/02/23.
//

import XCTest
import CoreLocation
@testable import TripMap

final class MapViewModelTests: XCTestCase {
    
    private var sut: MapViewModel!
    private let coordinateA = CLLocationCoordinate2DMake(20, 20)
    private let coordinateB = CLLocationCoordinate2DMake(30, 30)
    
    override func setUp() {
        super.setUp()
        
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
        
        sut = MapViewModel(trip: trip)
    }
    
    func test_pinObjects() {
        XCTAssertEqual(sut.pinObjects.count, 2)
    }
    
    func test_updateStatus() {
        // Given
        let pin = sut.getPinWith(latitude: coordinateA.latitude, longitude: coordinateA.longitude)!
        
        // When
        sut.updateStatus(for: .init(latitude: coordinateA.latitude, longitude: coordinateA.longitude))
        
        // Then
        XCTAssertFalse(pin.visited)
    }
    
    func test_getPinWith() {
        // Given
        let expectedLatitude = coordinateA.latitude
        let expectedLongitude = coordinateA.longitude
        
        // When
        let pin = sut.getPinWith(latitude: coordinateA.latitude, longitude: coordinateA.longitude)!
        
        // Then
        XCTAssertEqual(pin.lat, expectedLatitude)
        XCTAssertEqual(pin.lng, expectedLongitude)
    }
    
    func test_createNewPinViewModel() {
        // Given
        let expectedCoordinates = coordinateA
        
        // When
        let viewModel = sut.createNewPinViewModel(coordinates: expectedCoordinates)
        
        // Then
        XCTAssertEqual(viewModel.prefilledName, nil)
        XCTAssertEqual(viewModel.prefilledDescription, nil)
    }
    
    func test_createEditPinViewModel() {
        // Given
        let expectedCoordinates = coordinateA
        
        // When
        let viewModel = sut.createEditPinViewModel(coordinates: expectedCoordinates)
        
        // Then
        XCTAssertEqual(viewModel.prefilledName, "Pin A")
    }
    
    func test_filter() {
        // Given
        let showVisited = true
        let showNotVisited = false
        
        // When
        sut.setFilter(MapFilterViewModel.Filter(showVisited: showVisited, showNotVisited: showNotVisited, pins: []))
        let filterViewModel = sut.createMapFilterViewModel()
        
        // Then
        XCTAssertEqual(filterViewModel.showVisited, showVisited)
        XCTAssertEqual(filterViewModel.showNotvisited, showNotVisited)
    }
    
}
