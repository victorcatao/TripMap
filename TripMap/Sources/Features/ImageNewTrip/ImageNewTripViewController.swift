//
//  ImageNewTripViewController.swift
//  TripMap
//
//  Created by Victor Catão on 03/01/23.
//

import UIKit

final class ImageNewTripViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Qual imagem melhor representa essa sua viagem?"
        label.font = .systemFont(ofSize: 36, weight: .medium)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        
        let screenWidth = UIScreen.main.bounds.size.width
        let spaceBetweenItems: CGFloat = 4
        let collectionTrailingAndLeadingSpace: CGFloat = 16*2
        layout.itemSize = CGSize(width: ((screenWidth-(collectionTrailingAndLeadingSpace))/2) - spaceBetweenItems,
                                 height: 100)
        layout.minimumLineSpacing = spaceBetweenItems * 2
        layout.minimumInteritemSpacing = spaceBetweenItems

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ImageNewTripCollectionViewCell.self, forCellWithReuseIdentifier: "ImageNewTripCollectionViewCell")
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        
        return collection
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: ImageNewTripViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: ImageNewTripViewModel) {
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
        let barButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didTapDismiss))
        barButton.tintColor = .white
        navigationItem.rightBarButtonItem = barButton

        view.backgroundColor = .systemBlue
        
        view.addSubview(questionLabel)
        view.addSubview(collectionView)
        
        questionLabel
            .pin(.top, to: view.topAnchor, constant: 70)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        collectionView
            .pin(.top, to: questionLabel.bottomAnchor, constant: 24)
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.bottomAnchor)
    }
    
    @objc
    private func didTapDismiss() {
        dismiss(animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ImageNewTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageNewTripCollectionViewCell", for: indexPath) as! ImageNewTripCollectionViewCell
        myCell.setupWith(image: viewModel.getImage(at: indexPath.item))
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectImage(at: indexPath.item) { [weak self] trip in
            if let trip = trip {
                let viewModel = SuccessNewTripViewModel(trip: trip)
                let vc = SuccessNewTripViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(vc, animated: true)
            } else {
                //error
            }
            
        }
    }
}
