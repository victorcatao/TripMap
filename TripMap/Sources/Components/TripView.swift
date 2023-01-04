//
//  TripView.swift
//  TripMap
//
//  Created by Victor Catão on 04/01/23.
//

import UIKit

final class TripView: UIView {
    
    // MARK: - Views
    
    private lazy var tripImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 4
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tripNameLabel, tripPinsLabel])
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    private lazy var tripNameLabel: OutlinedLabel = {
        let label = OutlinedLabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50.0, weight: .heavy)
        label.textColor = .white
        label.outlineColor = .black
        label.outlineWidth = 5

        return label
    }()
    
    private lazy var tripPinsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
        label.textColor = .white

        return label
    }()
    
    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func setupTrip(name: String?, image: UIImage?, pinQuantity: Int) {
        tripNameLabel.text = name
        tripImageView.image = image
        tripPinsLabel.text = pinQuantity == 1 ? "\(pinQuantity) pin" : "\(pinQuantity) pins"
        tripPinsLabel.isHidden = pinQuantity <= 0
    }
    
    // MARK: - Private Methods

    private func setupView() {
        addSubview(tripImageView)
        addSubview(stackView)
        
        tripImageView
            .pin(.leading, to: leadingAnchor)
            .pin(.top, to: topAnchor)
            .pin(.trailing, to: trailingAnchor)
            .pin(.bottom, to: bottomAnchor)
            .pin(.height, relation: .equalToConstant, constant: 150)
        
        stackView
            .pin(.centerY, to: centerYAnchor)
            .pin(.leading, to: leadingAnchor, constant: 16)
            .pin(.trailing, to: trailingAnchor, constant: -16)
    }
}

