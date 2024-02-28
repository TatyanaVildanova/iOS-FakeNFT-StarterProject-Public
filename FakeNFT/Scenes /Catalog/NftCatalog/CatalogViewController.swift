//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Эмилия on 14.02.2024.
//

import UIKit

//MARK: - CatalogViewProtocol
protocol CatalogViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showErrorAlert()
}

//MARK: - CatalogViewController
final class CatalogViewController: UIViewController {
        
    //MARK: - Private properties
    private let servicesAssembly: ServicesAssembly
    private var presenter: CatalogPresenterProtocol?
    
    //MARK: - UI Components
    private lazy var activityIndicator = UIActivityIndicatorView()

    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Catalog.sortButton"), for: .normal)
        button.tintColor = UIColor(named: "YP Black")
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
    
    // MARK: - Initializers
    convenience init(servicesAssembly: ServicesAssembly) {
        let presenter = CatalogPresenter(service: servicesAssembly.nftCollectionService)
        self.init(servicesAssembly: servicesAssembly, presenter: presenter)
    }
    
    init(servicesAssembly: ServicesAssembly, presenter: CatalogPresenterProtocol) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.getNftCollections()
    }
    
    //MARK: - Private methods
    private func configure() {
        view.backgroundColor = UIColor(named: "YP White")
        configureNavBar()
        addViews()
        layoutViews()
    }
    
    private func configureNavBar() {
        let rightButton = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func addViews() {
        [tableView,
         activityIndicator].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

//MARK: - Actions
@objc extension CatalogViewController {
    private func didTapSortButton() {
        let alert = UIAlertController(
            title: NSLocalizedString("Sort", comment: ""),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let nameSortAction = UIAlertAction(
            title: NSLocalizedString("ByName", comment: ""),
            style: .default
        ){ action in
            self.presenter?.sortByName()
        }
        
        let countSortAction = UIAlertAction(
            title: NSLocalizedString("ByCount", comment: ""),
            style: .default
        ){ action in
            self.presenter?.sortByCount()
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Close", comment: ""),
            style: .cancel
        )
        
        [nameSortAction, countSortAction, cancelAction].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
}

//MARK: - CatalogViewProtocol
extension CatalogViewController: CatalogViewProtocol {
    func reloadData() {
        tableView.reloadData()
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: NSLocalizedString("Error.network", comment: ""),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Error.cancel", comment: ""),
            style: .cancel
        )
        
        let repeatAction = UIAlertAction(
            title: NSLocalizedString("Error.repeat", comment: ""),
            style: .default
        ){ [weak self] action in
            self?.presenter?.getNftCollections()
        }
        
        [cancelAction,
         repeatAction].forEach {
            alert.addAction($0)
        }
        
        alert.preferredAction = cancelAction
        present(alert, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.NftCollections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.identifier,
            for: indexPath
        ) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        guard let model = presenter?.getCellModel(for: indexPath) else { return cell }
        cell.configureCell(with: model)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let nftCollectionViewController = NftCollectionViewController(
            servicesAssembly: servicesAssembly,
            collection: presenter?.NftCollections[indexPath.row]
        )
        self.navigationController?.pushViewController(nftCollectionViewController, animated: true)
    }
}
