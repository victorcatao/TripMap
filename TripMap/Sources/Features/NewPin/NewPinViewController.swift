//
//  NewPinViewController.swift
//  TripMap
//
//  Created by Victor Catão on 14/01/23.
//

import UIKit

// MARK: - NewPinViewControllerDelegate

protocol NewPinViewControllerDelegate: AnyObject {
    func didCreateNewPin(_ pin: Pin)
}

// MARK: - NewPinViewController

final class NewPinViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: NewPinViewControllerDelegate?
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "what_name".localized
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "tour_eiffel".localized
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.text = viewModel.prefilledName
        return textField
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "description_optional".localized
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "tour_eiffel_description_placeholder".localized
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.text = viewModel.prefilledDescription
        return textField
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = "icon".localized
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var iconCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        layout.itemSize = CGSize(width: 50,
                                 height: 50)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TripIconCollectionViewCell.self, forCellWithReuseIdentifier: "TripIconCollectionViewCell")
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        
        return collection
    }()
    
    
    // MARK: - Private Properties
    
    private let viewModel: NewPinViewModelProtocol
    
    // MARK: - LifeCycle
    
    init(viewModel: NewPinViewModelProtocol) {
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
        
        title = "new_pin".localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        saveButton.tintColor = .white
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(iconLabel)
        view.addSubview(iconCollectionView)
        
        titleLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        nameTextField
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: titleLabel.bottomAnchor, constant: 8)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        descriptionLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: nameTextField.bottomAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        descriptionTextField
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: descriptionLabel.bottomAnchor, constant: 8)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        iconLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: descriptionTextField.bottomAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        iconCollectionView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: iconLabel.bottomAnchor, constant: 0)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.bottomAnchor, constant: -16)
    }
    
    @objc
    private func didTapSave() {
        viewModel.savePin(name: nameTextField.text, description: descriptionTextField.text) { [weak self] error in
            self?.showErrorMessage(message: error)
        } completion: { [weak self] pin in
            self?.dismiss(animated: true) {
                self?.delegate?.didCreateNewPin(pin)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewPinViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfEmojis
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripIconCollectionViewCell", for: indexPath) as! TripIconCollectionViewCell
        myCell.setupWith(model: viewModel.getEmoji(at: indexPath.item))

        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectPin(at: indexPath.item)
        collectionView.reloadData()
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension NewPinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            descriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
