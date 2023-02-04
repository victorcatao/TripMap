//
//  UIView+Constraints.swift
//
//  Created by Victor Catão on 28/08/22.
//

import UIKit

extension UIView {

    enum Anchor {
        case leading, top, trailing, bottom, width, height, centerX, centerY
        
        enum Relation {
            case equal, greaterThanOrEqual, lessThanOrEqual, greaterThanOrEqualToConstant, equalToConstant, lessThanOrEqualToConstant
        }
    }
    
    @discardableResult
    func pinToSuperview(
        _ anchor: Anchor,
        relation: Anchor.Relation = .equal,
        constant: CGFloat = 0,
        priority: UILayoutPriority = UILayoutPriority.required,
        multiplier: CGFloat = 1.0
    ) -> UIView {
        guard let superview else { return self }
        
        switch anchor {
        case .leading:
            return pin(anchor, relation: relation, to: superview.leadingAnchor, constant: constant, priority: priority)
        case .top:
            return pin(anchor, relation: relation, to: superview.topAnchor, constant: constant, priority: priority)
        case .trailing:
            return pin(anchor, relation: relation, to: superview.trailingAnchor, constant: constant, priority: priority)
        case .bottom:
            return pin(anchor, relation: relation, to: superview.bottomAnchor, constant: constant, priority: priority)
        case .width:
            return pin(anchor, relation: relation, to: superview.widthAnchor, constant: constant, priority: priority, multiplier: multiplier)
        case .height:
            return pin(anchor, relation: relation, to: superview.heightAnchor, constant: constant, priority: priority, multiplier: multiplier)
        case .centerX:
            return pin(anchor, relation: relation, to: superview.centerXAnchor, constant: constant, priority: priority)
        case .centerY:
            return pin(anchor, relation: relation, to: superview.centerYAnchor, constant: constant, priority: priority)
        }
    }

    @discardableResult
    func pin(
        _ anchor: Anchor,
        relation: Anchor.Relation = .equal,
        to layout: NSLayoutXAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = UILayoutPriority.required
    ) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        switch (anchor, relation) {
        case (.leading, .equal):
            constraint = leadingAnchor.constraint(equalTo: layout, constant: constant)
        case (.leading, .greaterThanOrEqual):
            constraint = leadingAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.leading, .lessThanOrEqual):
            constraint = leadingAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        case (.trailing, .equal):
            constraint = trailingAnchor.constraint(equalTo: layout, constant: constant)
        case (.trailing, .greaterThanOrEqual):
            constraint = trailingAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.trailing, .lessThanOrEqual):
            constraint = trailingAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        case (.centerX, .equal):
            constraint = centerXAnchor.constraint(equalTo: layout)
        case (.centerX, .equalToConstant):
            constraint = centerXAnchor.constraint(equalTo: layout, constant: constant)
        case (.centerX, .greaterThanOrEqual):
            constraint = centerXAnchor.constraint(greaterThanOrEqualTo: layout)
        case (.centerX, .greaterThanOrEqualToConstant):
            constraint = centerXAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.centerX, .lessThanOrEqual):
            constraint = centerXAnchor.constraint(lessThanOrEqualTo: layout)
        case (.centerX, .lessThanOrEqualToConstant):
            constraint = centerXAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        default:
            fatalError("Is not possible to add constraint \(anchor) and \(relation)")
        }
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func pin(
        _ anchor: Anchor,
        relation: Anchor.Relation = .equal,
        to layout: NSLayoutYAxisAnchor,
        constant: CGFloat = 0,
        priority: UILayoutPriority = UILayoutPriority.required
    ) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        switch (anchor, relation) {
        case (.top, .equal):
            constraint = topAnchor.constraint(equalTo: layout, constant: constant)
        case (.top, .greaterThanOrEqual):
            constraint = topAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.top, .lessThanOrEqual):
            constraint = topAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        case (.bottom, .equal):
            constraint = bottomAnchor.constraint(equalTo: layout, constant: constant)
        case (.bottom, .greaterThanOrEqual):
            constraint = bottomAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.bottom, .lessThanOrEqual):
            constraint = bottomAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        case (.centerY, .equal):
            constraint = centerYAnchor.constraint(equalTo: layout)
        case (.centerY, .equalToConstant):
            constraint = centerYAnchor.constraint(equalTo: layout, constant: constant)
        case (.centerY, .greaterThanOrEqual):
            constraint = centerYAnchor.constraint(greaterThanOrEqualTo: layout)
        case (.centerY, .greaterThanOrEqualToConstant):
            constraint = centerYAnchor.constraint(greaterThanOrEqualTo: layout, constant: constant)
        case (.centerY, .lessThanOrEqual):
            constraint = centerYAnchor.constraint(lessThanOrEqualTo: layout)
        case (.centerY, .lessThanOrEqualToConstant):
            constraint = centerYAnchor.constraint(lessThanOrEqualTo: layout, constant: constant)
        default:
            fatalError("Is not possible to add constraint \(anchor) and \(relation)")
        }
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func pin(
        _ anchor: Anchor,
        relation: Anchor.Relation = .equal,
        to layout: NSLayoutDimension? = nil,
        constant: CGFloat = 0,
        priority: UILayoutPriority = UILayoutPriority.required,
        multiplier: CGFloat = 1.0
    ) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint
        switch (anchor, relation) {
        case (.height, .equal):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = heightAnchor.constraint(equalTo: layout, multiplier: multiplier)
        case (.height, .equalToConstant):
            constraint = heightAnchor.constraint(equalToConstant: constant)
        case (.height, .greaterThanOrEqual):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = heightAnchor.constraint(greaterThanOrEqualTo: layout, multiplier: multiplier, constant: constant)
        case (.height, .greaterThanOrEqualToConstant):
            constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case (.height, .lessThanOrEqual):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = heightAnchor.constraint(lessThanOrEqualTo: layout, multiplier: multiplier, constant: constant)
        case (.height, .lessThanOrEqualToConstant):
            constraint = heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        case (.width, .equal):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = widthAnchor.constraint(equalTo: layout, multiplier: multiplier)
        case (.width, .equalToConstant):
            constraint = widthAnchor.constraint(equalToConstant: constant)
        case (.width, .greaterThanOrEqual):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = widthAnchor.constraint(greaterThanOrEqualTo: layout, multiplier: multiplier, constant: constant)
        case (.width, .greaterThanOrEqualToConstant):
            constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case (.width, .lessThanOrEqual):
            guard let layout = layout else { fatalError("Missing NSLayout") }
            constraint = widthAnchor.constraint(lessThanOrEqualTo: layout, multiplier: multiplier, constant: constant)
        case (.width, .lessThanOrEqualToConstant):
            constraint = widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        default:
            fatalError("Is not possible to add constraint \(anchor) and \(relation)")
        }
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
}
