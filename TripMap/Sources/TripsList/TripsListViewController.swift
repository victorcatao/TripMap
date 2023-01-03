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
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Private Properties

    private let viewModel = TripsListViewModel()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - Private Methods

    private func setupView() {
        title = "Minhas viagens"

        buildView()
        setupTableView()
    }

    private func buildView() {
        view.addSubview(tableView)
        
        tableView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: view.topAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TripListTableViewCell.self, forCellReuseIdentifier: "TripListTableViewCell")
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
}
