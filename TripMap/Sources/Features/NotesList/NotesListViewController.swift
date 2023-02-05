//
//  NotesListViewController.swift
//  TripMap
//
//  Created by Victor Catão on 29/01/23.
//

import UIKit
import Lottie

final class NotesListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("notes")
        animationView.loopMode = .loop
        animationView.play()
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 15)
        label.text = "empty_list_notes".localized
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    // MARK: - Private Methods

    private func setupView() {
        title = viewModel.getViewControllerTitle()
        
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapNewNote))
        navigationItem.rightBarButtonItem = newNoteButton

        view.addSubviews(tableView, emptyView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView
            .pin(.leading, to: view.leadingAnchor)
            .pin(.top, to: view.topAnchor)
            .pin(.trailing, to: view.trailingAnchor)
            .pin(.bottom, to: view.bottomAnchor)
        
        emptyView
            .pinToSuperview(.centerX)
            .pinToSuperview(.centerY)
            .pinToSuperview(.leading)
            .pinToSuperview(.trailing)
    }
    
    @objc
    private func didTapNewNote() {
        guard let viewController = viewModel.createViewControllerForNewNote() else { return }
        viewController.delegate = self
        self.present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func reloadData() {
        tableView.reloadData()
        emptyView.isHidden = viewModel.getNumberOfRows() > 0
    }
    
    private func didTapDeleteNote(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: viewModel.getNote(at: indexPath.row)?.title,
                                                message: "confirmation_delete_note".localized,
                                                preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: "cancel".localized, style: .cancel, handler: { _ in
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            })
        )

        alertController.addAction(
            UIAlertAction.init(title: "yes".localized, style: .default, handler: { _ in
                self.viewModel.deleteNote(at: indexPath.row)
                self.reloadData()
            })
        )

        self.present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete".localized) { [weak self] _, _, _ in
            self?.didTapDeleteNote(at: indexPath)
        }
        deleteAction.backgroundColor = .red
        deleteAction.image = .init(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return config
    }
}

// MARK: - NoteViewControllerDelegate

extension NotesListViewController: NoteViewControllerDelegate {
    func didCloseNoteViewController() {
        viewModel.reloadData()
        reloadData()
    }
}
