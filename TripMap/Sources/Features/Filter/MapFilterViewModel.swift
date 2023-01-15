//
//  MapFilterViewModel.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import Foundation

final class MapFilterViewModel {
    
    // MARK: - Public Properties

    struct Filter {
        let showVisited: Bool
        let showNotVisited: Bool
        let pins: [PinModel]
    }
    
    var numberOfEmojis: Int {
        return allPinEmojis.count
    }
    
    // MARK: - Private Properties

    private var filter: Filter?
    private var allPinEmojis = PinDatabase.allPinEmojis
    private(set) var showVisited: Bool
    private(set) var showNotvisited: Bool

    // MARK: - LifeCycle

    init(filter: Filter? = nil) {
        showVisited = true
        showNotvisited = true
        self.filter = filter
        self.showVisited = filter?.showVisited ?? true
        self.showNotvisited = filter?.showNotVisited ?? true
        
        guard let filter = filter, filter.pins.isEmpty == false else { return }
        for i in 0...(filter.pins.count - 1) {
            let pin = filter.pins[i]
            if pin.isSelected,
               let index = allPinEmojis.firstIndex(where: {$0.emoji == pin.emoji}) {
                allPinEmojis[index].isSelected = true
            }
        }
    }
    
    // MARK: - Public Methods

    func showVisited(_ show: Bool) {
        showVisited = show
    }
    
    func showNotVisited(_ show: Bool) {
        showNotvisited = show
    }

    func getEmoji(at index: Int) -> PinModel {
        return allPinEmojis[index]
    }
    
    func didSelectPin(at index: Int) {
        allPinEmojis[index].setSelected(!allPinEmojis[index].isSelected)
    }
    
    func createFilter() -> Filter {
        return Filter(
            showVisited: showVisited,
            showNotVisited: showNotvisited,
            pins: allPinEmojis.filter { $0.isSelected }
        )
    }

}
