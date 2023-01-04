//
//  SuccessNewTripViewController.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class SuccessNewTripViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Viagem criada com sucesso!"
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var tripImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 4
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
    
    private lazy var closeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Finalizar"
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
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(questionLabel)
        view.addSubview(tripImageView)
        view.addSubview(tripNameLabel)
        view.addSubview(closeButton)

        questionLabel
            .pin(.top, to: view.topAnchor, constant: 100)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        tripImageView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: questionLabel.bottomAnchor, constant: 32)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 150)
        
        tripNameLabel
            .pin(.centerY, to: tripImageView.centerYAnchor)
            .pin(.centerX, to: tripImageView.centerXAnchor)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        closeButton
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: tripImageView.bottomAnchor, constant: 32)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 44)
        
        tripImageView.image = UIImage(named: viewModel.tripImage ?? "1")
        tripNameLabel.text = viewModel.tripName
    }
    
    @objc
    private func didTapFinishButton() {
        presentingViewController?.viewWillAppear(true)
        dismiss(animated: true)
    }
    
}
