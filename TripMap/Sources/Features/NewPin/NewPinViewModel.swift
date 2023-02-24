//
//  NewPinViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//

import Foundation

// MARK: - NewPinViewModelProtocol

protocol NewPinViewModelProtocol: AnyObject {
    var prefilledName: String? { get }
    var prefilledDescription: String? { get }
    var numberOfEmojis: Int { get }
    
    func getEmoji(at index: Int) -> PinModel
    func didSelectPin(at index: Int)
    func savePin(name: String?, description: String?, error: @escaping (String) -> Void, completion: @escaping (Pin) -> Void)
}

// MARK: - NewPinViewModel

final class NewPinViewModel: NewPinViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let trip: Trip?
    private let coordinate: (latitude: Double, longitude: Double)
    private var allPinEmojis = PinDatabase.allPinEmojis
    private var pinToEdit: Pin?
    
    // MARK: - LifeCycle
    
    init(trip: Trip?,
         pinToEdit: Pin? = nil,
         latitude: Double,
         longitude: Double) {
        self.trip = trip
        self.coordinate = (latitude: latitude, longitude: longitude)
        self.pinToEdit = pinToEdit
        if pinToEdit != nil, let index = allPinEmojis.firstIndex(where: { $0.emoji == pinToEdit?.icon }) {
            allPinEmojis[index].setSelected(true)
        }
    }
    
    // MARK: - Public Properties
    
    var prefilledName: String? {
        return pinToEdit?.name
    }
    
    var prefilledDescription: String? {
        return pinToEdit?.pinDescription
    }
    
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
        guard let name else {
            error("fill_name".localized)
            return
        }
        guard let selectedPin = allPinEmojis.first(where: {$0.isSelected}) else {
            error("select_icon".localized)
            return
        }
        
        if let pinEdit = pinToEdit {
            DataManager.shared.updatePin(pinEdit, name: name, description: description, icon: selectedPin.emoji)
            completion(pinEdit)
        } else {
            let pin = DataManager.shared.createPin(
                name: name,
                description: description,
                emoji: selectedPin.emoji,
                trip: trip,
                coordinate: coordinate)
            
            if let pin {
                completion(pin)
            } else {
                error("generic_error".localized)
            }
        }
    }
}
