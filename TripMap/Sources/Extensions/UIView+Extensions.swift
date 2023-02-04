//
//  UIView+Extensions.swift
//  TripMap
//
//  Created by Victor Catão on 04/02/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
