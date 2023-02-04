//
//  TutorialViewController.swift
//  TripMap
//
//  Created by Victor Catão on 04/02/23.
//

import UIKit
import Lottie

final class MapTutorialViewController: UIViewController {
    
    // MARK: - Views

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0

        return view
    }()
    
    private lazy var tapAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("tap-hold")
        view.animation = animation
        view.loopMode = .loop

        return view
    }()
    
    private lazy var tapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "tutorial_pin_label".localized
        return label
    }()
    
    private lazy var locationAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("locate-gps")
        view.animation = animation
        view.loopMode = .loop

        return view
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "tutorial_location_label".localized
        return label
    }()
    
    private lazy var filterAnimationView: LottieAnimationView = {
        let view = LottieAnimationView()
        let animation = LottieAnimation.named("filter")
        view.animation = animation
        view.loopMode = .loop

        return view
    }()
    
    private lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "tutorial_filter_label".localized
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("close".localized, for: .normal)
        button.layer.cornerRadius = 4.0
        button.backgroundColor = .black
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
        }
    }
    
    // MARK: - Private Methods

    private func setUpView() {
        view.addSubviews(contentView, closeButton)
        contentView.addSubviews(tapAnimationView, tapLabel, locationAnimationView, locationLabel, filterAnimationView, filterLabel)
        
        contentView
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
            .pinToSuperview(.centerY, relation: .equalToConstant)
        
        // tap
        tapAnimationView
            .pinToSuperview(.top, constant: 0)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 150)
            
        tapLabel
            .pin(.top, to: tapAnimationView.bottomAnchor, constant: -6)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
        
        // location
        locationAnimationView
            .pin(.top, to: tapLabel.bottomAnchor, constant: 24)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 130)
        
        locationLabel
            .pin(.top, to: locationAnimationView.bottomAnchor, constant: 0)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
        
        // filter
        filterAnimationView
            .pin(.top, to: locationLabel.bottomAnchor, constant: 24)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 100)
        
        filterLabel
            .pin(.top, to: filterAnimationView.bottomAnchor, constant: 16)
            .pinToSuperview(.leading, constant: 16)
            .pinToSuperview(.trailing, constant: -16)
            .pinToSuperview(.bottom, constant: -60)
        
        closeButton
            .pin(.top, to: filterLabel.bottomAnchor, constant: 40)
            .pinToSuperview(.centerX)
            .pin(.height, relation: .equalToConstant, constant: 40)
            .pin(.width, relation: .equalToConstant, constant: 130)
        
        tapAnimationView.play()
        locationAnimationView.play()
        filterAnimationView.play()
    }
    
    @objc
    private func didTapClose() {
        UserDefaults.standard.setValue(true, forKey: "userDidSeeMapTutorial")
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.backgroundColor = .black.withAlphaComponent(0)
        }
        
        dismiss(animated: true)
    }
    
}
