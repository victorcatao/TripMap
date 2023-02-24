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
    private var tripHelper: Trip!
    private var pinAHelper: Pin!
    private var pinBHelper: Pin!
    
    override func setUp() {
        super.setUp()
        
        DataManager.shared.createTrip(name: "Trip test", image: "") { trip in
            self.tripHelper = trip
            
            DataManager.shared.createPin(name: "Pin A", description: "Desc Pin A", emoji: "🏕", trip: trip!, coordinate: (self.coordinateA.latitude, self.coordinateA.longitude)) { _, pinA in
                self.pinAHelper = pinA!
            }
            
            DataManager.shared.createPin(name: "Pin B", description: "Desc Pin B", emoji: "🏡", trip: trip!, coordinate: (self.coordinateB.latitude, self.coordinateB.longitude)) { _, pinB in
                self.pinBHelper = pinB!
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        DataManager.shared.deleteTrip(tripHelper)
        
        tripHelper = nil
        pinAHelper = nil
        pinBHelper = nil
    }
    
    func test_prefilledName() {
        sut = NewPinViewModel(trip: nil, pinToEdit: pinAHelper, latitude: coordinateA.latitude, longitude: coordinateA.longitude)
        
        XCTAssertEqual(sut.prefilledName, pinAHelper.name)
    }
    
    func test_prefilledDescription() {
        sut = NewPinViewModel(trip: nil,
                              pinToEdit: pinAHelper,
                              latitude: coordinateA.latitude,
                              longitude: coordinateA.longitude)
        
        XCTAssertEqual(sut.prefilledDescription, pinAHelper.pinDescription)
    }
    
    func test_savePin() {
        sut = NewPinViewModel(trip: tripHelper, latitude: 0, longitude: 0)
        sut.didSelectPin(at: 0)
        
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
