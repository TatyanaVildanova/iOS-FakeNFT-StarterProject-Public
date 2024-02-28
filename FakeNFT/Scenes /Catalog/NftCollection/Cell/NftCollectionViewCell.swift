//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Эмилия on 20.02.2024.
//

import UIKit

//MARK: - CatalogNFTCellModel
struct NftCollectionCellModel {
    let id: String
    let nameNft: String
    let price: Float
    let isLiked: Bool
    let isInTheCart: Bool
    let rating: Int
    let url: URL
}

protocol NftCollectionViewCellDelegate: AnyObject {
    func updateLike(for: IndexPath, state: Bool)
    func updateOrder(for: IndexPath)
}

//MARK: - NftCollectionViewCell
final class NftCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let identifier = "NftCollectionViewCell"
    var indexPath: IndexPath?
    var delegate: NftCollectionViewCellDelegate?
    
    //MARK: - Private properties
    private var idNft: String?
    private var likeState: Bool = false
    
    //MARK: - UI Components
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "noActiveLike"), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapLikeButton),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingView: StarRatingView = {
        let ratingView = StarRatingView()
        return ratingView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP Black")
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Catalog.CardEmpty"), for: .normal)
        button.tintColor = .black
        button.addTarget(
            self, action:
                #selector(didTapCartButton),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var nameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func configureCell(with model: NftCollectionCellModel) {
        self.idNft = model.id
        imageView.kf.setImage(with: model.url)
        nameLabel.text = model.nameNft.components(separatedBy: " ").first
        priceLabel.text = String(model.price) + " ETH"
        ratingView.update(rating: model.rating)
        cartButton.setImage(setCart(isInTheCart: model.isInTheCart), for: .normal)
        likeButton.setImage(setLike(isLiked: model.isLiked), for: .normal)
    }
    
    func setLike(isLiked: Bool) -> UIImage? {
        self.likeState = isLiked
        return likeState ? UIImage(named: "activeLike") : UIImage(named: "noActiveLike")
    }
    
    func setCart(isInTheCart: Bool) -> UIImage? {
        isInTheCart ? UIImage(named: "Catalog.CardFull") : UIImage(named: "Catalog.CardEmpty")
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        [imageView,
         likeButton,
         ratingView,
         nameAndPriceStackView,
         cartButton,
         activityIndicator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            nameAndPriceStackView.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            nameAndPriceStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameAndPriceStackView.widthAnchor.constraint(equalToConstant: 68),
            nameAndPriceStackView.heightAnchor.constraint(equalToConstant: 38),
            
            cartButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 25),
            activityIndicator.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func showLoading() {
        activityIndicator.startAnimating()
    }
    
    private func hideLoading() {
        activityIndicator.stopAnimating()
    }
}

//MARK: - Actions
@objc extension NftCollectionViewCell {
    private func didTapLikeButton() {
        guard let indexPath else { return }
        delegate?.updateLike(for: indexPath, state: likeState)
    }
    
    private func didTapCartButton() {
        guard let indexPath else { return }
        delegate?.updateOrder(for: indexPath)
    }
}
