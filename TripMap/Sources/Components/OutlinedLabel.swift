//
//  OutlinedLabel.swift
//  OutlinedLabel
//
//  Created by Adriano Rezena on 12/06/21.
//

import UIKit

class OutlinedLabel: UILabel {
    
    private let gradientLayer = CAGradientLayer()
    
    
    // MARK: - Outline properties
    @IBInspectable
    var outlineWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var outlineColor: UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Lifecycle
    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor

        let c = UIGraphicsGetCurrentContext()
        
        // Outline
        c?.setLineWidth(outlineWidth)
        c?.setLineJoin(.round)
        c?.setTextDrawingMode(.stroke)
        self.textAlignment = .center

            self.textColor = outlineColor

        super.drawText(in:rect)

        // Shadow
        if let shadowColor = shadowColor {
            super.shadowColor = shadowColor
            super.shadowOffset = shadowOffset
            super.drawText(in:rect)
        }
        
        c?.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = CGSize(width: 0, height: 0)
        super.drawText(in:rect)

        self.shadowOffset = shadowOffset
    }
}
