//
//  SuccessNewTripViewController.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit
import Lottie

final class SuccessNewTripViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var lottieAnimationView = LottieAnimationView()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "success_trip_creation".localized
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "finish".localized
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapFinishButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Private Properties
    
    private let viewModel: SuccessNewTripViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: SuccessNewTripViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLottieAnimation()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(questionLabel)
        view.addSubview(lottieAnimationView)
        view.addSubview(closeButton)
        
        questionLabel
            .pin(.top, to: view.topAnchor, constant: 70)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        lottieAnimationView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: questionLabel.bottomAnchor, constant: 32)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 200)
        
        closeButton
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: lottieAnimationView.bottomAnchor, constant: 32)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 44)
    }
    
    @objc
    private func didTapFinishButton() {
        presentingViewController?.viewWillAppear(true)
        dismiss(animated: true)
    }
    
    private func startLottieAnimation() {
        let animation = LottieAnimation.named("trip-lottie-animation")
        lottieAnimationView.animation = animation
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
    }
    
}
