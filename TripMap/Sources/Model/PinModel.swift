//
//  PinModel.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import Foundation

struct PinModel {
    let emoji: String
    let backgroundColor: String
    var isSelected: Bool
    
    mutating func setSelected(_ selected: Bool) {
        self.isSelected = selected
    }
}

struct PinDatabase {
    static let allPinEmojis = [
        PinModel(emoji: "🏖", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🏜", backgroundColor: "", isSelected: false),
        PinModel(emoji: "⛰", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🌋", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🏕", backgroundColor: "", isSelected: false),
        PinModel(emoji: "⛺️", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🛖", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🏡", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🕍", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🕌", backgroundColor: "", isSelected: false),
        PinModel(emoji: "⛪️", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🎢", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🗽", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🗿", backgroundColor: "", isSelected: false),
        PinModel(emoji: "✈️", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🛟", backgroundColor: "", isSelected: false),
        PinModel(emoji: "⚽️", backgroundColor: "", isSelected: false),
        PinModel(emoji: "🍽", backgroundColor: "", isSelected: false),
    ]
}
