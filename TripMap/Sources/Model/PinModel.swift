//
//  PinModel.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import Foundation

struct PinModel {
    let emoji: String
    var isSelected: Bool
    
    mutating func setSelected(_ selected: Bool) {
        self.isSelected = selected
    }
}

struct PinDatabase {
    static let allPinEmojis = [
        PinModel(emoji: "🏖", isSelected: false),
        PinModel(emoji: "🏜", isSelected: false),
        PinModel(emoji: "⛰️", isSelected: false),
        PinModel(emoji: "🌋", isSelected: false),
        PinModel(emoji: "🏕", isSelected: false),
        PinModel(emoji: "⛺️", isSelected: false),
        PinModel(emoji: "🛖", isSelected: false),
        PinModel(emoji: "🏡", isSelected: false),
        PinModel(emoji: "🕍", isSelected: false),
        PinModel(emoji: "🕌", isSelected: false),
        PinModel(emoji: "⛪️", isSelected: false),
        PinModel(emoji: "🎢", isSelected: false),
        PinModel(emoji: "🗽", isSelected: false),
        PinModel(emoji: "🗿", isSelected: false),
        PinModel(emoji: "✈️", isSelected: false),
        PinModel(emoji: "🛟", isSelected: false),
        PinModel(emoji: "⚽️", isSelected: false),
        PinModel(emoji: "🍽", isSelected: false),
        PinModel(emoji: "🥐", isSelected: false),
        PinModel(emoji: "🥯", isSelected: false),
        PinModel(emoji: "🧇", isSelected: false),
        PinModel(emoji: "🍕", isSelected: false),
        PinModel(emoji: "🍔", isSelected: false),
        PinModel(emoji: "🍣", isSelected: false),
        PinModel(emoji: "⛷️", isSelected: false),
        PinModel(emoji: "🏄‍♂️", isSelected: false),
        PinModel(emoji: "🚴", isSelected: false),
        PinModel(emoji: "🛹", isSelected: false),
        PinModel(emoji: "🎸", isSelected: false),
        PinModel(emoji: "🚣", isSelected: false),
        PinModel(emoji: "🏟️", isSelected: false),
        PinModel(emoji: "🏛️", isSelected: false),
        PinModel(emoji: "🏠", isSelected: false),
        PinModel(emoji: "🏥", isSelected: false),
        PinModel(emoji: "⛩️", isSelected: false),
        PinModel(emoji: "🌇", isSelected: false),
        PinModel(emoji: "🎡", isSelected: false),
        PinModel(emoji: "🚝", isSelected: false),
        PinModel(emoji: "🚋", isSelected: false),
        PinModel(emoji: "🚌", isSelected: false),
        PinModel(emoji: "🚕", isSelected: false),
        PinModel(emoji: "🎉", isSelected: false),
        PinModel(emoji: "💻", isSelected: false),
        PinModel(emoji: "📚", isSelected: false),
        PinModel(emoji: "📍", isSelected: false),
        PinModel(emoji: "🛴", isSelected: false),
        PinModel(emoji: "🪂", isSelected: false),
        PinModel(emoji: "🎆", isSelected: false)
    ]
}
