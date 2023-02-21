//
//  NewPinViewModelTests.swift
//  TripMapTests
//
//  Created by Victor Catão on 19/02/23.
//

import XCTest
import CoreLocation
@testable import TripMap

final class NewPinViewModelTests: XCTestCase {
    
    private var sut: NewPinViewModelProtocol!
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
        
        trip.pins = NSSet(array: [pinA])
        
        sut = NewPinViewModel(trip: trip, latitude: coordinateB.latitude, longitude: coordinateB.longitude)
    }
    
    func test_prefilledName() {
        // Given
        let pinA = Pin(context: DataManager.shared.context)
        pinA.name = "Pin A"
        pinA.pinDescription = "Desc Pin A"
        pinA.visited = true
        pinA.lat = coordinateA.latitude
        pinA.lng = coordinateA.longitude
        
        // When
        sut = NewPinViewModel(trip: nil, pinToEdit: pinA, latitude: coordinateA.latitude, longitude: coordinateA.longitude)
        
        // Then
        XCTAssertEqual(sut.prefilledName, pinA.name)
    }
    
    func test_prefilledDescription() {
        // Given
        let pinA = Pin(context: DataManager.shared.context)
        pinA.name = "Pin A"
        pinA.pinDescription = "Desc Pin A"
        pinA.visited = true
        pinA.lat = coordinateA.latitude
        pinA.lng = coordinateA.longitude
        
        // When
        sut = NewPinViewModel(trip: nil,
                              pinToEdit: pinA,
                              latitude: coordinateA.latitude,
                              longitude: coordinateA.longitude)
        
        // Then
        XCTAssertEqual(sut.prefilledDescription, pinA.pinDescription)
    }
    
    func test_savePin() {
        // Given
        let trip = Trip(context: DataManager.shared.context)
        trip.name = "trip"
        
        sut = NewPinViewModel(trip: trip, latitude: 0, longitude: 0)
        sut.didSelectPin(at: 0)
        
        // When
        sut.savePin(
            name: "Pin Test",
            description: "Description Test",
            error: { _ in
                XCTFail("Something went wrong. Pin not saved.")
            },
            completion: { pin in
                XCTAssertEqual(pin.name, "Pin Test")
            })
    }
    
}


//var prefilledName: String? { get }
//var prefilledDescription: String? { get }
//var numberOfEmojis: Int { get }
//
//func getEmoji(at index: Int) -> PinModel
//func didSelectPin(at index: Int)
//func savePin(name: String?, description: String?, error: @escaping (String) -> Void, completion: @escaping (Pin) -> Void)
