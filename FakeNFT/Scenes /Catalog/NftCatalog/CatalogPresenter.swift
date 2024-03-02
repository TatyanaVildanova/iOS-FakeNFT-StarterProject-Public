//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Эмилия on 16.02.2024.
//

import Foundation

//MARK: - CatalogPresenterProtocol
protocol CatalogPresenterProtocol {
    var view: CatalogViewProtocol? { get set }
    var NftCollections: [NftCollection] { get }
    func getCellModel(for indexPath: IndexPath) -> CatalogNftCellModel
    func getNftCollections()
    func sortByCount()
    func sortByName()
}

//MARK: - CatalogPresenter
final class CatalogPresenter: CatalogPresenterProtocol {
    
    //MARK: - Properties
    weak var view: CatalogViewProtocol?
    var NftCollections: [NftCollection] = []
    
    //MARK: - Private properties
    private let service: NftCollectionService
    private let sortStorage: SortNftStorage
    
    // MARK: - Initializers
    convenience init(service: NftCollectionService) {
        let storage = SortNftStorage()
        self.init(service: service, sortStorage: storage)
    }
    
    init(service: NftCollectionService, sortStorage: SortNftStorage) {
        self.service = service
        self.sortStorage = sortStorage
    }
    
    //MARK: - Methods
    func getNftCollections() {
        view?.showLoading()
        service.loadNft( completion: { [weak self] result in
            switch result {
            case .success(let collections):
                self?.NftCollections = collections
                self?.checkSort()
                self?.view?.hideLoading()
                self?.view?.reloadData()
            case .failure(let error):
                print(error)
                self?.view?.hideLoading()
                self?.view?.showErrorAlert()
            }
        })
    }
    
    func getCellModel(for indexPath: IndexPath) -> CatalogNftCellModel {
        convertToCellModel(collection: NftCollections[indexPath.row])
    }
    
    func sortByCount() {
        sortStorage.saveSort(.byCount)
        NftCollections = NftCollections.sorted {
            $0.nfts.count > $1.nfts.count
        }
        view?.reloadData()
    }
    
    func sortByName() {
        sortStorage.saveSort(.byName)
        NftCollections = NftCollections.sorted {
            $0.name < $1.name
        }
        view?.reloadData()
    }
    
    //MARK: - Private methods
    private func convertToCellModel(collection: NftCollection) -> CatalogNftCellModel {
        CatalogNftCellModel(
            nameNft: collection.name,
            countNft: collection.nfts.count,
            url: collection.coverURL
        )
    }
    
    private func checkSort() {
        let sort = sortStorage.getSort()
        switch sort {
        case .byName:
            sortByName()
        case .byCount:
            sortByCount()
        }
    }
}
