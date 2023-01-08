//
//  NoteViewController.swift
//  TripMap
//
//  Created by Victor Catão on 06/01/23.
//

import UIKit

final class NoteViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Título"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "Título da sua nota"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Nota"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private lazy var noteTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        textView.layer.cornerRadius = 6.0
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        return textView
    }()
    
    
    // MARK: - Private Properties
    
    private let viewModel: NoteViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: NoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fillData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(noteLabel)
        view.addSubview(noteTextView)
        
        titleLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        titleTextField
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: titleLabel.bottomAnchor, constant: 8)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        noteLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: titleTextField.bottomAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        noteTextView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: noteLabel.bottomAnchor, constant: 8)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    }
    
    private func fillData() {
        let (title, text) = viewModel.getTitleAndText()
        titleTextField.text = title
        noteTextView.text = text
    }
    
    @objc
    private func didTapSave() {
        guard let title = titleTextField.text else { return }
        viewModel.saveNote(title: title, text: noteTextView.text)
        self.dismiss(animated: true)
    }
}
