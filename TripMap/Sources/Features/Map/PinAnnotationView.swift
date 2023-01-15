//
//  PinAnnotationView.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import MapKit
import UIKit

final class PinAnnotationView: MKAnnotationView {

    // MARK: - Public Properties
    
    class Annotation: MKPointAnnotation {
        let emoji: String
        let name: String
        let visited: Bool
        
        init(emoji: String, name: String, visited: Bool) {
            self.emoji = emoji
            self.name = name
            self.visited = visited
        }
    }
    
    // MARK: - Views
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 25
        label.clipsToBounds = true

        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true

        return label
    }()
    
    // MARK: Initialization

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

        canShowCallout = true
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupUI() {
        backgroundColor = .clear

        addSubview(emojiLabel)
        addSubview(nameLabel)
        
        emojiLabel
            .pin(.leading, to: leadingAnchor)
            .pin(.top, to: topAnchor)
            .pin(.trailing, to: trailingAnchor)
        
        nameLabel
            .pin(.top, to: emojiLabel.bottomAnchor, constant: 4)
            .pin(.leading, to: leadingAnchor)
            .pin(.trailing, to: trailingAnchor)
            .pin(.bottom, to: bottomAnchor)
    }
    
    func setUpWith(annotation: Annotation) {
        self.annotation = annotation
        emojiLabel.text = annotation.emoji
        nameLabel.text = annotation.name
        
        alpha = annotation.visited ? 0.5 : 1.0
    }
}
