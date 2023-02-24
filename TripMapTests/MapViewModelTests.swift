//
//  MapViewModelTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 19/02/23.
//

import XCTest
import CoreLocation
import CoreData.NSManagedObjectContext
@testable import TripMap

final class MapViewModelTests: XCTestCase {
    
    private var sut: MapViewModel!
    private let coordinateA = CLLocationCoordinate2DMake(20, 20)
    private let coordinateB = CLLocationCoordinate2DMake(30, 30)
    private var tripHelper: Trip!
    private var pinAHelper: Pin!
    private var pinBHelper: Pin!
    
    override func setUp() {
        super.setUp()
        
        tripHelper = DataManager.shared.createTrip(name: "Trip test", image: "")
        pinAHelper = DataManager.shared.createPin(name: "Pin A", description: "Desc Pin A", emoji: "🏕", trip: tripHelper, coordinate: (self.coordinateA.latitude, self.coordinateA.longitude))
        pinBHelper = DataManager.shared.createPin(name: "Pin B", description: "Desc Pin B", emoji: "🏡", trip: tripHelper, coordinate: (self.coordinateB.latitude, self.coordinateB.longitude))
        sut = MapViewModel(trip: tripHelper)
    }
    
    override func tearDown() {
        super.tearDown()
        
        DataManager.shared.deleteTrip(tripHelper)
        
        tripHelper = nil
        pinAHelper = nil
        pinBHelper = nil
    }
    
    func test_pinObjects() {
        XCTAssertEqual(sut.pinObjects.count, 2)
    }
    
    func test_updateStatus() {
        // Given
        let pin = sut.getPinWith(latitude: coordinateA.latitude, longitude: coordinateA.longitude)!
        let expectedStatus = !pin.visited
        
        // When
        sut.updateStatus(for: .init(latitude: coordinateA.latitude, longitude: coordinateA.longitude))
        
        // Then
        XCTAssertEqual(pin.visited, expectedStatus)
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
