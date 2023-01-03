//
//  TripListTableViewCell.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit

final class TripListTableViewCell: UITableViewCell {
    
    // MARK: - Views

    private lazy var tripImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        image.layer.cornerRadius = 4
        image.image = UIImage(named: "2")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        
        return image
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
    
    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(tripImageView)
        contentView.addSubview(tripNameLabel)
        
        tripImageView
            .pin(.leading, to: contentView.leadingAnchor, constant: 8)
            .pin(.top, to: contentView.topAnchor, constant: 8)
            .pin(.trailing, to: contentView.trailingAnchor, constant: -8)
            .pin(.bottom, to: contentView.bottomAnchor, constant: -8)
            .pin(.height, relation: .equalToConstant, constant: 150)
        
        tripNameLabel
            .pin(.centerY, to: contentView.centerYAnchor)
            .pin(.leading, to: contentView.leadingAnchor, constant: 16)
            .pin(.trailing, to: contentView.trailingAnchor, constant: -16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func setupWith(trip: Trip) {
        tripNameLabel.text = trip.name?.uppercased()
    }
}
