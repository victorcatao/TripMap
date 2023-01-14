//
//  String+Extensions.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
