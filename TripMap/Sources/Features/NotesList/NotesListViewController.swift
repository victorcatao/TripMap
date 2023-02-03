//
//  NotesListViewController.swift
//  TripMap
//
//  Created by Victor Catão on 29/01/23.
//

import UIKit

final class NotesListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    // MARK: - Private Properties
    
    private let viewModel: NotesListViewModel
    
    // MARK: - LifeCycle
    
    init(viewModel: NotesListViewModel) {
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
        title = viewModel.getViewControllerTitle()
        
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapNewNote))
        navigationItem.rightBarButtonItem = newNoteButton

        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: view.topAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
    }
    
    @objc
    private func didTapNewNote() {
        guard let viewController = viewModel.createViewControllerForNewNote() else { return }
        viewController.delegate = self
        self.present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let note = viewModel.getNote(at: indexPath.row)
        cell.textLabel?.text = note?.title
        cell.detailTextLabel?.text = note?.text
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewModel.createViewControllerForNote(at: indexPath.row) else { return }
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - NoteViewControllerDelegate

extension NotesListViewController: NoteViewControllerDelegate {
    func didCloseNoteViewController() {
        viewModel.reloadData()
        tableView.reloadData()
    }
}
