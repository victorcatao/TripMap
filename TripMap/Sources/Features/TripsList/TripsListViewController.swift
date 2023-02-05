//
//  TripsList.swift
//  TripMap
//
//  Created by Victor Catão on 02/01/23.
//

import UIKit
import Lottie

final class TripsListViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var segmentedControl: UISegmentedControl = {
        let nextTrispAction = UIAction(title: "next_trips".localized) { [weak self] _ in
            self?.didTapNextTrips()
        }
        let finishedTripsAction = UIAction(title: "finished_trips".localized) { [weak self] _ in
            self?.didTapFinishedTrips()
        }
        let segmentedControl = UISegmentedControl(frame: .zero, actions: [nextTrispAction, finishedTripsAction])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
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
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("vacation")
        animationView.loopMode = .loop
        animationView.play()
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        label.text = "empty_list_trips".localized
        
        view.addSubviews(animationView, label)
        
        animationView
            .pinToSuperview(.leading)
            .pinToSuperview(.top)
            .pinToSuperview(.trailing)
            .pin(.width, relation: .equal, to: view.widthAnchor)
            .pin(.height, relation: .equalToConstant, constant: 170)
        
        label
            .pinToSuperview(.leading, constant: 16)
            .pin(.top, to: animationView.bottomAnchor, constant: 20)
            .pinToSuperview(.trailing, constant: -16)
            .pinToSuperview(.bottom)
        
        return view
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
        reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = "my_trips".localized
        
        buildView()
        setupTableView()
    }
    
    private func buildView() {
        view.backgroundColor = .white

        view.addSubviews(
            segmentedControl,
            tableView,
            newTripButton,
            allTripsButton,
            emptyView
        )
        
        emptyView
            .pinToSuperview(.centerX)
            .pinToSuperview(.centerY)
            .pinToSuperview(.leading)
            .pinToSuperview(.trailing)
        
        segmentedControl
            .pin(.leading, to: view.leadingAnchor, constant: 16)
            .pin(.top, to: view.safeAreaLayoutGuide.topAnchor)
            .pin(.trailing, to: view.trailingAnchor, constant: -16)

        tableView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: segmentedControl.bottomAnchor, constant: 8)
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
        
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "search".localized
        searchBar.sizeToFit()

        tableView.tableHeaderView = searchBar
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
        viewModel.deleteTrip(at: indexPath.row)
        UIView.transition(with: tableView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.reloadData() })
    }
    
    private func didTapNotesforTrip(at indexPath: IndexPath) {
        let trip = viewModel.getTrip(at: indexPath.row)
        let viewController = NotesListViewController(viewModel: NotesListViewModel(trip: trip))
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func didTapFinishTrip(at indexPath: IndexPath) {
        viewModel.finishTrip(index: indexPath.row, section: indexPath.section)
        reloadData()
    }
    
    private func didTapNextTrips(){
        viewModel.updateSelection(.notFinished)
        reloadData()
    }
    
    private func didTapFinishedTrips(){
        viewModel.updateSelection(.finished)
        reloadData()
    }
    
    private func reloadData() {
        tableView.reloadData()
        emptyView.isHidden = viewModel.getNumberOfRows() > 0
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TripsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripListTableViewCell", for: indexPath) as! TripListTableViewCell
        let trip = viewModel.getTrip(at: indexPath.row)
        cell.setupWith(trip: trip)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = viewModel.getTrip(at: indexPath.row)
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

// MARK: - UISearchBarDelegate

extension TripsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setFilteredText(searchText)
        reloadData()
    }
}
