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
        title = "Minhas viagens"
        
        buildView()
        setupTableView()
    }
    
    private func buildView() {
        view.addSubview(tableView)
        view.addSubview(newTripButton)
        
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
    
    private func deleteTrip(at indexPath: IndexPath) {
        viewModel.deleteTrip(at: indexPath.row)
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    private func openNotesforTrip(at indexPath: IndexPath) {
        let trip = viewModel.trips[indexPath.row]
        let viewController = NoteViewController(viewModel: NoteViewModel(trip: trip))
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TripsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTableViewCell", for: indexPath) as! TripListTableViewCell
        cell.setupWith(trip: viewModel.trips[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = viewModel.trips[indexPath.row]
        let mapViewController = MapViewController(viewModel: MapViewModel(trip: trip))
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            self?.deleteTrip(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = .init(systemName: "trash")

        let notesAction = UIContextualAction(style: .normal, title: "Notes") { [weak self] _, _, _ in
            self?.openNotesforTrip(at: indexPath)
        }
        notesAction.backgroundColor = .systemOrange
        notesAction.image = .init(systemName: "pencil")

        let config = UISwipeActionsConfiguration(actions: [deleteAction, notesAction])
        
        return config
    }
}
