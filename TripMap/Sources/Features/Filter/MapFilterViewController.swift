//
//  MapFilterViewController.swift
//  TripMap
//
//  Created by Victor Catão on 15/01/23.
//

import UIKit

// MARK: - MapFilterViewControllerDelegate

protocol MapFilterViewControllerDelegate: AnyObject {
    func didApplyFilter(_ filter: MapFilterViewModel.Filter)
}

// MARK: - MapFilterViewController

final class MapFilterViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var visitedSwitchView = createSwitchView(
        title: "show_visited".localized,
        isOn: viewModel.showVisited,
        target: self,
        action: #selector(didChangeVisitedSwitchValue(_:))
    )

    private lazy var notVisitedSwitchView = createSwitchView(
        title: "show_not_visited".localized,
        isOn: viewModel.showNotvisited,
        target: self,
        action: #selector(didChangeNotVisitedSwitchValue(_:))
    )
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = "icon".localized
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private lazy var iconCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 18, left: 0, bottom: 10, right: 0)
        
        layout.itemSize = CGSize(width: 50, height: 50)
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
    
    private let viewModel: MapFilterViewModel
    
    // MARK: - Public Properties
    
    weak var delegate: MapFilterViewControllerDelegate?

    // MARK: - LifeCycle
    
    init(viewModel: MapFilterViewModel) {
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
        
        title = "filter_title".localized
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        let filterButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapFilter))
        filterButton.tintColor = .white
        navigationItem.rightBarButtonItem = filterButton
        
        view.addSubview(visitedSwitchView)
        view.addSubview(notVisitedSwitchView)
        view.addSubview(iconLabel)
        view.addSubview(iconCollectionView)
        
        visitedSwitchView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 60)
        
        notVisitedSwitchView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: visitedSwitchView.bottomAnchor)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.height, relation: .equalToConstant, constant: 60)
        
        iconLabel
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: notVisitedSwitchView.bottomAnchor, constant: 16)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
        
        iconCollectionView
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: iconLabel.bottomAnchor, constant: 0)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.bottomAnchor, constant: -16)
    }
    
    private func createSwitchView(title: String, isOn: Bool, target: Any?, action: Selector) -> UIView {
        let contentView = UIView()

        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = isOn
        switchView.tintColor = .systemGray6
        switchView.layer.cornerRadius = switchView.frame.height / 2.0
        switchView.backgroundColor = .systemGray6
        switchView.clipsToBounds = true
        switchView.addTarget(target, action: action, for: .valueChanged)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white.withAlphaComponent(0.8)
        
        contentView.addSubview(label)
        contentView.addSubview(switchView)
        contentView.addSubview(dividerView)
        
        label
            .pin(.centerY, to: contentView.centerYAnchor)
            .pin(.leading, to: contentView.leadingAnchor)
        
        switchView
            .pin(.centerY, to: contentView.centerYAnchor)
            .pin(.trailing, to: contentView.trailingAnchor)
        
        dividerView
            .pin(.leading, to: contentView.leadingAnchor)
            .pin(.trailing, to: contentView.trailingAnchor)
            .pin(.bottom, to: contentView.bottomAnchor)
            .pin(.height, relation: .equalToConstant, constant: 1)
        
        return contentView
    }
    
    @objc
    private func didTapFilter() {
        let filter = viewModel.createFilter()
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didApplyFilter(filter)
        }
    }
    
    @objc
    func didChangeVisitedSwitchValue(_ sender: UISwitch) {
        viewModel.showVisited(sender.isOn)
    }
    
    @objc
    func didChangeNotVisitedSwitchValue(_ sender: UISwitch) {
        viewModel.showNotVisited(sender.isOn)
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MapFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

