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
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
        ])
    }
}

//MARK: - Actions
@objc extension NftCollectionViewController {
}
