//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Эмилия on 14.02.2024.
//

import UIKit

//MARK: - CatalogTableViewCell
final class CatalogTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "CatalogTableViewCell"
    
    //MARK: - UI Components
    private lazy var tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tableNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "YP Black")
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureCell(with model: CatalogNftCellModel) {
        tableImageView.kf.setImage(with: model.url)
        tableNameLabel.text = "\(model.nameNft) (\(model.countNft))"
    }
    
    //MARK: - Private methods
    private func setupCell() {
        addViews()
        layoutViews()
    }
    
    private func addViews() {
        [tableImageView,
         tableNameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            tableImageView.heightAnchor.constraint(equalToConstant: 140),
            tableImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            tableNameLabel.leadingAnchor.constraint(equalTo: tableImageView.leadingAnchor),
            tableNameLabel.topAnchor.constraint(equalTo: tableImageView.bottomAnchor, constant: 4),
            tableNameLabel.trailingAnchor.constraint(equalTo: tableImageView.trailingAnchor),
            tableNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
}
