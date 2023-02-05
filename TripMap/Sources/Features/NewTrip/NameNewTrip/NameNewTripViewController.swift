//
//  NameNewTripViewController.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class NameNewTripViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var successDelegate: SuccessNewTripViewControllerDelegate?
    
    // MARK: - Views
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "where_are_you_going".localized
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
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)

        return button
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private var composeViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - Private Methods
    
    private func setupView() {
        let barButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapDismiss))
        barButton.tintColor = .white
        navigationItem.rightBarButtonItem = barButton
        
        view.backgroundColor = .systemBlue
        
        view.addSubview(questionLabel)
        view.addSubview(textField)
        view.addSubview(nextButton)
        
        questionLabel
            .pin(.top, to: view.topAnchor, constant: 70)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        textField
            .pin(.top, to: questionLabel.bottomAnchor, constant: 16)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        nextButton
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 44)
            .pin(.width, relation: .equalToConstant, constant: 44)
        
        composeViewBottomConstraint = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -16)
        composeViewBottomConstraint?.isActive = true
    }
    
    private func goToNextStep() {
        guard let tripName = textField.text, !tripName.isEmpty else { return }
        
        let viewController = ImageNewTripViewController(viewModel: ImageNewTripViewModel(tripName: tripName))
        viewController.successDelegate = successDelegate
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func didTapNext() {
        goToNextStep()
    }
    
    @objc
    private func didTapDismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - Keyboard Functions

    @objc
    private func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        composeViewBottomConstraint?.constant = -(keyboardHeight! - view.safeAreaInsets.bottom + 44)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification){
        composeViewBottomConstraint?.constant = -16
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension NameNewTripViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goToNextStep()
        return true
    }
}
