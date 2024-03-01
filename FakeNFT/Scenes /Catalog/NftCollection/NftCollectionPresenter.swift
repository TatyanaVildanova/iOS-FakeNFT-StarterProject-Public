//
//  NftCollectionPresenter.swift
//  FakeNFT
//
//  Created by Эмилия on 20.02.2024.
//

import Foundation

//MARK: - NftCollectionPresenterProtocol
protocol NftCollectionPresenterProtocol: AnyObject {
    var nfts: [Nft] { get }
    var view: NftCollectionViewProtocol? { get set }
    func getNftCollection()
    func getCellModel(for indexPath: IndexPath) -> NftCollectionCellModel
    func loadData()
}

//MARK: - NftCollectionPresenter
final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Properties
    weak var view: NftCollectionViewProtocol?
    var nfts: [Nft] = []
    
    //MARK: - Private properties
    private let service: ServicesAssembly
    private var profile: Profile?
    private var nftCollection: NftCollection?

    // MARK: - Initializers
    init(service: ServicesAssembly, nftCollection: NftCollection?) {
        self.service = service
        self.nftCollection = nftCollection
        self.getProfile()
    }
    
    //MARK: - Methods
    func getNftCollection() {
        guard let nftCollection else { return }
        nftCollection.nfts.forEach {
            view?.showLoading()
            service.nftService.loadNft(id: $0, completion: { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    self?.view?.hideLoading()
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.hideLoading()
                    self?.view?.showErrorAlert()
                    print(error)
                }
            })
        }
    }
    
    func loadData() {
        guard let nftCollection else { return }
        view?.setupData(
            name: nftCollection.name,
            cover: nftCollection.coverURL,
            author: nftCollection.author,
            description: nftCollection.description)
    }
    
    func getCellModel(for indexPath: IndexPath) -> NftCollectionCellModel {
        convertToCellModel(nft: nfts[indexPath.row])
    }
    
    //MARK: - Private methods
    private func convertToCellModel(nft: Nft) -> NftCollectionCellModel {
        NftCollectionCellModel(
            id: nft.id,
            nameNft: nft.name,
            price: nft.price,
            isLiked: service.profileService.likeState(for: nft.id),
            isInTheCart: service.orderService.cartState(for: nft.id),
            rating: nft.rating,
            url: nft.images[0])
    }
    
    private func getProfile() {
        service.profileService.loadProfile(completion: {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let error):
                print(error)
            }
        })
    }
}
