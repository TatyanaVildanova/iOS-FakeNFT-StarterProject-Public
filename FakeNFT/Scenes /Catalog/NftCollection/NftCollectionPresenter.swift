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
    var numberOfItems: Int { get }
    var contentSize: Double? { get }
    func getNftCollection()
    func getCellModel(for indexPath: IndexPath) -> NftCollectionCellModel
    func loadData()
    func updateLikeState(for indexPath: IndexPath, state: Bool)
    func updateOrderState(for indexPath: IndexPath)
    func getAuthorURL() -> URL?
}

//MARK: - NftCollectionPresenter
final class NftCollectionPresenter: NftCollectionPresenterProtocol {
    
    //MARK: - Properties
    let dispatchGroup = DispatchGroup()
    weak var view: NftCollectionViewProtocol?
    var nfts: [Nft] = []
    
    var numberOfItems: Int {
        nfts.count
    }
    
    var contentSize: Double? {
        guard let count = nftCollection?.nfts.count else { return nil }
        let lineSize = (Double(count) / 3).rounded(.up) * (192 + 8)
        let size = Double(490 + lineSize)
        return size
    }

    //MARK: - Private properties
    private let service: ServicesAssembly
    private var profile: Profile?
    private var nftCollection: NftCollection?
    
    // MARK: - Initializers
    init(service: ServicesAssembly, nftCollection: NftCollection?) {
        self.service = service
        self.nftCollection = nftCollection
    }
    
    //MARK: - Methods
    func getNftCollection() {
        guard let nftCollection else { return }
        nftCollection.nfts.forEach {
            view?.showLoading()
            dispatchGroup.enter()
            service.nftService.loadNft(id: $0, completion: { [weak self] result in
                defer { self?.dispatchGroup.leave() }
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    self?.getLikeState(nft: nft)
                    self?.getCartState(nft: nft)
                case .failure(let error):
                    self?.view?.showErrorAlert()
                    print(error)
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            self.view?.hideLoading()
            self.view?.updateCollectionView()
        }
    }
    
    func getLikeState(nft: Nft) -> Bool {
        service.profileService.likeState(for: nft.id)
    }
    
    func getCartState(nft: Nft) -> Bool {
        service.orderService.cartState(for: nft.id)
    }
    
    func updateLikeState(for indexPath: IndexPath, state: Bool) {
        service.profileService.setLike(id: nfts[indexPath.row].id, completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                self?.view?.showErrorAlert()
                print(error)
            }
        })
    }
    
    func updateOrderState(for indexPath: IndexPath) {
        service.orderService.setOrders(id: nfts[indexPath.row].id, completion: { [weak self] result in
            switch result {
            case .success:
                self?.view?.updateCell(indexPath: indexPath)
            case .failure(let error):
                self?.view?.showErrorAlert()
                print(error)
            }
        })
    }
    
    func getAuthorURL() -> URL? {
        //Тут должен быть url на автора коллекции nfts[0].author, но в API лежит нерабочая ссылка
        var url =  URL(string: "https://practicum.yandex.ru")
        var authorURL = url
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
            isLiked: getLikeState(nft: nft),
            isInTheCart: getCartState(nft: nft),
            rating: nft.rating,
            url: nft.images[0])
    }
}
