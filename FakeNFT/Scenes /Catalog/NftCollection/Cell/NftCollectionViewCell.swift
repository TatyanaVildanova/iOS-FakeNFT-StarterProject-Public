//
//  NftCollectionViewCell.swift
//  FakeNFT
//
//  Created by Эмилия on 20.02.2024.
//

import UIKit

//MARK: - NftCollectionViewCell
final class NftCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public properties
    static let identifier = "NftCollectionViewCell"
    
    //MARK: - UI Components
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
    func configureCell() {
        imageView.image = UIImage(named: "NFTcard")
        nameLabel.text = "Archie"
        priceLabel.text = "1 ETH"
        ratingView.update(rating: 5)
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
         cartButton].forEach {
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
        ])
    }
}

//MARK: - Actions
@objc extension NftCollectionViewCell {
    private func didTapLikeButton() {
        //TODO: добавление лайка
    }
    
    private func didTapCartButton() {
        //TODO: добавление в корзину
    }
}
