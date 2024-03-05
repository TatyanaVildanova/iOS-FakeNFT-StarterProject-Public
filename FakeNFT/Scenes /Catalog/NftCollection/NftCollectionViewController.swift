//
//  NftCollectionViewController.swift
//  FakeNFT
//
//  Created by Эмилия on 15.02.2024.
//

import UIKit

//MARK: - NftCollectionViewProtocol
protocol NftCollectionViewProtocol: AnyObject {
    func updateCollectionView()
    func setupData(name: String, cover: URL, author: String, description: String)
    func updateCell(indexPath: IndexPath)
    func showLoading()
    func hideLoading()
    func showErrorAlert()
}

//MARK: - CollectionViewSettings
private struct CollectionViewSettings {
    static let interitemSpacing: CGFloat = 9
    static let lineSpacing: CGFloat = 8
    static let itemsPerLine: CGFloat = 3
    static let collectionItemWidth: CGFloat = 108
    static let collectionItemHeight: CGFloat = 192
}

//MARK: - NftCollectionViewController
final class NftCollectionViewController: UIViewController {
    
    //MARK: - Private properties
    private let servicesAssembly: ServicesAssembly
    private var presenter: NftCollectionPresenterProtocol?

    //MARK: - UI Components
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: presenter?.contentSize ?? view.frame.height)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var authorButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "YP Blue"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.addTarget(
            self,
            action: #selector(didTapAuthorButton),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 0
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            NftCollectionViewCell.self,
            forCellWithReuseIdentifier: NftCollectionViewCell.identifier)
        return collectionView
    }()
    
    // MARK: - Initializers
    convenience init(servicesAssembly: ServicesAssembly, collection: NftCollection?){
        let presenter = NftCollectionPresenter(service: servicesAssembly, nftCollection: collection)
        self.init(servicesAssembly: servicesAssembly, presenter: presenter)
    }
    
    init(servicesAssembly: ServicesAssembly, presenter: NftCollectionPresenterProtocol) {
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
        presenter?.getNftCollection()
        presenter?.loadData()
        configure()
    }
    
    //MARK: - Private methods
    private func configure() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [imageView,
         titleLabel,
         authorLabel,
         authorButton,
         descriptionLabel,
         collectionView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -100),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: scrollView.contentSize.height),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.widthAnchor.constraint(equalToConstant: 112),
            authorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            authorButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            authorButton.heightAnchor.constraint(equalToConstant: 28),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

//MARK: - Actions
@objc extension NftCollectionViewController {
    private func didTapAuthorButton() {
        let url = presenter?.getAuthorURL()
        guard let url = url else { return }
        let webView = AuthorViewController(url: url)
        navigationController?.pushViewController(webView, animated: true)
    }
}

//MARK: - NftCollectionViewProtocol
extension NftCollectionViewController: NftCollectionViewProtocol {
    func setupData(
        name: String,
        cover: URL,
        author: String,
        description: String
    ) {
        imageView.kf.setImage(with: cover)
        titleLabel.text = name
        authorButton.setTitle(author, for: .normal)
        descriptionLabel.text = description
    }
    
    func updateCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
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
            self?.presenter?.getNftCollection()
        }
        
        [cancelAction,
         repeatAction].forEach {
            alert.addAction($0)
        }
        
        alert.preferredAction = cancelAction
        present(alert, animated: true)
    }
}

//MARK: - NftCollectionViewCellDelegate
extension NftCollectionViewController: NftCollectionViewCellDelegate {
    func updateOrder(for indexPath: IndexPath) {
        presenter?.updateOrderState(for: indexPath)
    }
    
    func updateLike(for indexPath: IndexPath, state: Bool) {
        presenter?.updateLikeState(for: indexPath, state: state)
    }
}

//MARK: - UICollectionViewDataSource
extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.numberOfItems
    }
    
        func collectionView(
            _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NftCollectionViewCell.identifier,
            for: indexPath
        ) as? NftCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        
        guard let model = presenter?.getCellModel(for: indexPath) else { return cell }
        cell.configureCell(with: model)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: CollectionViewSettings.collectionItemWidth,
            height: CollectionViewSettings.collectionItemHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        CollectionViewSettings.interitemSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        CollectionViewSettings.lineSpacing
    }
}
