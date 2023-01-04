//
//  NameNewTripViewController.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class NameNewTripViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Para onde você vai?"
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Paris",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        textField.textColor = .white.withAlphaComponent(0.8)
        textField.returnKeyType = .next
        textField.delegate = self

        return textField
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: NameNewTripViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: NameNewTripViewModel) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(questionLabel)
        view.addSubview(textField)
        
        questionLabel
            .pin(.top, to: view.topAnchor, constant: 100)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        textField
            .pin(.top, to: questionLabel.bottomAnchor, constant: 16)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
    }
    
}

// MARK: - UITextFieldDelegate

extension NameNewTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let tripName = textField.text else { return true }
        
        let vc = ImageNewTripViewController(viewModel: ImageNewTripViewModel(tripName: tripName))
        navigationController?.pushViewController(vc, animated: true)
        return true
    }
}
