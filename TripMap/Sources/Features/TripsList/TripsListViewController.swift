//
//  TripsList.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit

final class TripsListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsMultipleSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var newTripButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.attributedTitle = AttributedString(
            "+",
            attributes: AttributeContainer([
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .medium)
            ])
        )
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 0,
            bottom: 13,
            trailing: 0
        )
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(didTapAddTripButton), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        
        return button
    }()
    
    private lazy var allTripsButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.addTarget(self, action: #selector(didTapAllTripsButton), for: .touchUpInside)
        button.setImage(UIImage(named: "logo"), for: .normal)
        button.imageEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 30
        
        return button
    }()
    
    // MARK: - Private Properties
    
    private let viewModel = TripsListViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = "my_trips".localized
        
        buildView()
        setupTableView()
    }
    
    private func buildView() {
        view.addSubview(tableView)
        view.addSubview(newTripButton)
        view.addSubview(allTripsButton)
        
        tableView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: view.topAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
        
        newTripButton
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
            .pin(.height, relation: .equalToConstant, constant: 60)
            .pin(.width, relation: .equalToConstant, constant: 60)

        allTripsButton
            .pin(.trailing, to: view.trailingAnchor, constant: -16)
            .pin(.bottom, to: newTripButton.topAnchor, constant: -8)
            .pin(.height, relation: .equalToConstant, constant: 60)
            .pin(.width, relation: .equalToConstant, constant: 60)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TripListTableViewCell.self, forCellReuseIdentifier: "TripListTableViewCell")
    }
    
    @objc
    private func didTapAddTripButton() {
        let newTripViewController = NameNewTripViewController(viewModel: NameNewTripViewModel())
        let navigation = UINavigationController(rootViewController: newTripViewController)
        present(navigation, animated: true)
    }
    
    @objc
    private func didTapAllTripsButton() {
        let mapViewController = MapViewController(viewModel: MapViewModel(trip: nil))
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    private func didTapDeleteTrip(at indexPath: IndexPath) {
        viewModel.deleteTrip(at: indexPath.row, section: indexPath.section)
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    private func didTapNotesforTrip(at indexPath: IndexPath) {
        let trip = viewModel.getTrip(for: indexPath.row, section: indexPath.section)
        let viewController = NoteViewController(viewModel: NoteViewModel(trip: trip))
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func didTapFinishTrip(at indexPath: IndexPath) {
        viewModel.finishTrip(index: indexPath.row, section: indexPath.section)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TripsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.getNumberOfSections() <= 1 { return nil }

        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.text = section == 0 ? "next_trips".localized : "finished_trips".localized
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .systemGray2
        label.textAlignment = .center
        
        view.addSubview(label)
        
        label
            .pin(.leading, to: view.leadingAnchor, constant: 8)
            .pin(.top, to: view.topAnchor, constant: 8)
            .pin(.trailing, to: view.trailingAnchor, constant: -8)
            .pin(.bottom, to: view.bottomAnchor)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.getNumberOfSections() <= 1 { return 0 }
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTableViewCell", for: indexPath) as! TripListTableViewCell
        let trip = viewModel.getTrip(for: indexPath.row, section: indexPath.section)
        cell.setupWith(trip: trip)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = viewModel.getTrip(for: indexPath.row, section: indexPath.section)
        let mapViewController = MapViewController(viewModel: MapViewModel(trip: trip))
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete".localized) { [weak self] _, _, _ in
            self?.didTapDeleteTrip(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = .init(systemName: "trash")

        let notesAction = UIContextualAction(style: .normal, title: "notes".localized) { [weak self] _, _, _ in
            self?.didTapNotesforTrip(at: indexPath)
        }
        notesAction.backgroundColor = .systemOrange
        notesAction.image = .init(systemName: "pencil")
        
        let finished = UIContextualAction(style: .normal, title: "finish".localized) { [weak self] _, _, _ in
            self?.didTapFinishTrip(at: indexPath)
        }
        finished.backgroundColor = .systemBlue
        finished.image = .init(systemName: "folder")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, notesAction, finished])
        
        return config
    }
}
