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
    var numberOfItems: Int { get }
    var contentSize: Double? { get }
    func getNftCollection()
    func getCellModel(for indexPath: IndexPath) -> NftCollectionCellModel
    func loadData()
    func updateLikeState(for indexPath: IndexPath)
    func updateOrderState(for indexPath: IndexPath)
    func getAuthorURL() -> URL?
}

//MARK: - NftCollectionPresenter
final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Properties
    weak var view: NftCollectionViewProtocol?
    
    var numberOfItems: Int {
        nfts.count
    }
    
    var contentSize: Double? {
        guard let count = nftCollection?.nfts.count else { return nil }
        let lineSize = (Double(count) / 3).rounded(.up) * (192 + 8)
        let size = Double(490 + lineSize)
        return size
    }
    
    let userInitiatedQueue = DispatchQueue.global(qos: .userInitiated)
    
    //MARK: - Private properties
    private let service: ServicesAssembly
    private var profile: Profile?
    private var nftCollection: NftCollection?
    private var nfts: [Nft] = []
    private var likes: [String] = []
    private var orders: [String] = []
    
    // MARK: - Initializers
    init(service: ServicesAssembly, nftCollection: NftCollection?) {
        self.service = service
        self.nftCollection = nftCollection
    }
    
    //MARK: - Methods
    func getNftCollection() {
        let dispatchGroup = DispatchGroup()
        
        guard let nftCollection else { return }
        view?.showLoading()
        
        dispatchGroup.enter()
        service.profileService.loadLikes(completion: { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
            case .failure(let error):
                print(error)
            }
        })
        
        dispatchGroup.enter()
        service.orderService.loadOrders(completion: { [weak self] result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let orders):
                self?.orders = orders.nfts
            case .failure(let error):
                print(error)
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            nftCollection.nfts.forEach {
                self.service.nftService.loadNft(id: $0, completion: { [weak self] result in
                    switch result {
                    case .success(let nft):
                        self?.userInitiatedQueue.async {
                            self?.nfts.append(nft)
                        }
                        self?.view?.hideLoading()
                        self?.view?.updateCollectionView()
                    case .failure(let error):
                        self?.view?.showErrorAlert()
                        print(error)
                    }
                })
            }
        }
    }
    
    func updateLikeState(for indexPath: IndexPath) {
        let nftId = nfts[indexPath.row].id
        var updatedLikes = self.likes
        
        if updatedLikes.contains(nftId) {
            updatedLikes.removeAll { $0 == nftId }
        } else {
            updatedLikes.append(nftId)
        }
        self.likes = updatedLikes
        
        service.profileService.setLike(id: nftId, likes: self.likes, completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.userInitiatedQueue.async {
                    self?.profile = profile
                    guard !profile.likes.isEmpty else { return }
                    self?.likes = profile.likes
                }
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                self?.view?.showErrorAlert()
                print(error)
            }
        })
    }
    
    func updateOrderState(for indexPath: IndexPath) {
        let nftId = nfts[indexPath.row].id
        var updatedOrders = self.orders
        
        if updatedOrders.contains(nftId) {
            updatedOrders.removeAll { $0 == nftId }
        } else {
            updatedOrders.append(nftId)
        }
        self.orders = updatedOrders
        
        service.orderService.setOrders(id: nftId, orders: self.orders, completion: { [weak self] result in
            switch result {
            case .success(let orders):
                self?.userInitiatedQueue.async {
                    guard !orders.nfts.isEmpty else { return }
                    self?.orders = orders.nfts
                }
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                self?.view?.showErrorAlert()
                print(error)
            }
        })
    }
    
    func getAuthorURL() -> URL? {
        //Тут должен быть url на автора коллекции, но в API лежит нерабочая ссылка
        let authorURL = URL(string: "https://practicum.yandex.ru")
        return authorURL
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
            isLiked: likes.contains(nft.id),
            isInTheCart: orders.contains(nft.id),
            rating: nft.rating,
            url: nft.images[0])
    }
}
