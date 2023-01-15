//
//  NewPinViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//

import Foundation

final class NewPinViewModel {

    // MARK: - Private Properties

    private let trip: Trip?
    
    private let coordinate: (lat: Double, lng: Double)
    
    private var allPinEmojis = PinDatabase.allPinEmojis
    
    // MARK: - LifeCycle

    init(trip: Trip?, latitude: Double, longitude: Double) {
        self.trip = trip
        self.coordinate = (lat: latitude, lng: longitude)
    }
    
    // MARK: - Public Properties
    
    var numberOfEmojis: Int {
        return allPinEmojis.count
    }
    
    // MARK: - Public Methods

    func getEmoji(at index: Int) -> PinModel {
        return allPinEmojis[index]
    }
    
    func didSelectPin(at index: Int) {
        for i in 0...allPinEmojis.count-1 {
            allPinEmojis[i].setSelected(false)
        }
        allPinEmojis[index].setSelected(true)
    }
    
    func savePin(name: String?, description: String?, error: @escaping (String) -> Void, completion: @escaping (Pin) -> Void) {
        guard name != nil else {
            error("fill_name".localized)
            return
        }
        guard let selectedPin = allPinEmojis.first(where: {$0.isSelected}) else {
            error("select_icon".localized)
            return
        }
        
        let managedContext = DataManager.shared.context
        
        let pin = Pin(context: managedContext)
        pin.name = name
        pin.pinDescription = description
        pin.lat = coordinate.lat
        pin.lng = coordinate.lng
        pin.icon = selectedPin.emoji
        
        if let trip = trip {
            trip.addToPins(pin)
        }

        do {
            try managedContext.save()
        } catch(_) {
            error("generic_error".localized)
        }
        
        completion(pin)
    }
}
