//
//  NftCollectionViewController.swift
//  FakeNFT
//
//  Created by Эмилия on 15.02.2024.
//

import UIKit

//MARK: - NftCollectionViewController
final class NftCollectionViewController: UIViewController {
    
    //MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        //TODO: картинка из сети
        imageView.image = UIImage(named: "Beige")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Beige"
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
        button.setTitle("John Doe", for: .normal)
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
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей."
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
        collectionView.register(
            NftCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NftCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -100),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            
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
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//MARK: - Actions
@objc extension NftCollectionViewController {
    private func didTapAuthorButton() {
        //TODO: переход на экран автора
    }
}
