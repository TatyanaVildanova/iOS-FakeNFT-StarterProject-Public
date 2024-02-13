//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Эмилия on 14.02.2024.
//

import UIKit

//MARK: - CatalogViewController
final class CatalogViewController: UIViewController {
    
    //MARK: - UI Components
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Catalog.sortButton"), for: .normal)
        button.tintColor = .segmentActive
        button.addTarget(
            self,
            action: #selector(didTapSortButton),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CatalogTableViewCell.self,
            forCellReuseIdentifier: CatalogTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        configureNavBar()
        addViews()
        layoutViews()
    }
    
    private func configureNavBar() {
        let rightButton = UIBarButtonItem(customView: sortButton)
        navigationItem.setRightBarButton(rightButton, animated: false)
    }
    
    private func addViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - objc extension
@objc extension CatalogViewController {
    private func didTapSortButton() {
        // TODO: сортировка
    }
}

//MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: заполнение таблицы
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.identifier,
            for: indexPath
        ) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell()
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    //TODO: переход на экран NFT коллекции
}
