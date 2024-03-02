//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Эмилия on 22.02.2024.
//

import UIKit

//MARK: - NftCollectionViewCell
final class StarRatingView: UIStackView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func update(rating: Int) {
        updateRating(rating: rating)
    }
    
    // MARK: - Private methods
    private func updateRating(rating: Int) {
        for (index, subview) in arrangedSubviews.enumerated() {
            guard let starImageView = subview as? UIImageView else { continue }
            starImageView.image = index < rating ? UIImage(named: "starDoneIcon") : UIImage(named: "starEmptyIcon")
        }
    }
    
    private func configure() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "starEmptyIcon")
            starImageView.contentMode = .scaleAspectFit
            addArrangedSubview(starImageView)
        }
    }
}
