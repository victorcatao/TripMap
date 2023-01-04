//
//  TripListTableViewCell.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit

final class TripListTableViewCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var tripView = TripView()

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(tripView)
        
        tripView
            .pin(.leading, to: contentView.leadingAnchor, constant: 8)
            .pin(.top, to: contentView.topAnchor, constant: 8)
            .pin(.trailing, to: contentView.trailingAnchor, constant: -8)
            .pin(.bottom, to: contentView.bottomAnchor, constant: -8)
            .pin(.height, relation: .equalToConstant, constant: 150)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func setupWith(trip: Trip) {
        tripView.setupTrip(name: trip.name?.uppercased(),
                           image: UIImage(named: trip.imageName ?? "1"))
    }
}
