//
//  NftCollectionPresenter.swift
//  FakeNFT
//
//  Created by Эмилия on 20.02.2024.
//

import Foundation

//MARK: - NftCollectionPresenterProtocol
protocol NftCollectionPresenterProtocol: AnyObject {
    var view: NftCollectionViewProtocol? { get set }
}

//MARK: - NftCollectionPresenter
final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Properties
    weak var view: NftCollectionViewProtocol?
    
    //MARK: - Private properties

    // MARK: - Initializers

    
    //MARK: - Public methods

    
    //MARK: - Private methods

}
