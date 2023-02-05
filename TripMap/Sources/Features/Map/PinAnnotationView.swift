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
    
    private lazy var contentEmojiImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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

        contentEmojiImageView.addSubview(emojiImageView)
        addSubviews(contentEmojiImageView, emojiLabel, nameLabel)
        
        contentEmojiImageView
            .pinToSuperview(.top)
            .pinToSuperview(.centerX)
            .pin(.height, relation: .equalToConstant, constant: 50)
            .pin(.width, relation: .equalToConstant, constant: 50)
        
        emojiImageView
            .pinToSuperview(.centerX)
            .pinToSuperview(.centerY)
            .pin(.height, relation: .equalToConstant, constant: 30)
            .pin(.width, relation: .equalToConstant, constant: 30)
        
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
        
        emojiLabel.isHidden = annotation.visited
        contentEmojiImageView.isHidden = !emojiLabel.isHidden
        
        if annotation.visited, let emojiImage = annotation.emoji.image() {
            emojiImageView.image = convertToGrayScale(image: emojiImage)
        }
    }
    
    // MARK: - Helpers

    private func convertToGrayScale(image: UIImage) -> UIImage {
        // Create image rectangle with current image width/height
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        // Grayscale color space
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height

        // Create bitmap content with current image size and grayscale colorspace
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()

        // Create a new UIImage object
        let newImage = UIImage(cgImage: imageRef!)

        return newImage
    }
    
}
