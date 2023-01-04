//
//  ImageNewTripCollectionViewCell.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class ImageNewTripCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Views

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        imageView
            .pin(.leading, to: contentView.leadingAnchor)
            .pin(.top, to: contentView.topAnchor)
            .pin(.trailing, to: contentView.trailingAnchor)
            .pin(.bottom, to: contentView.bottomAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func setupWith(image: UIImage?) {
        imageView.image = image
    }

}
