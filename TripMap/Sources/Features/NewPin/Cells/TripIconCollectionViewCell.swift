//
//  TripIconCollectionViewCell.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//

import UIKit

final class TripIconCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        
        label
            .pin(.leading, to: contentView.leadingAnchor)
            .pin(.top, to: contentView.topAnchor)
            .pin(.trailing, to: contentView.trailingAnchor)
            .pin(.bottom, to: contentView.bottomAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func setupWith(model: PinModel) {
        label.text = model.emoji

        contentView.backgroundColor = model.isSelected ? .white : .clear
        contentView.layer.cornerRadius = contentView.frame.width/2
    }

}

