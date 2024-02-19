//
//  NftCatalogService.swift
//  FakeNFT
//
//  Created by Эмилия on 16.02.2024.
//

import Foundation

typealias NftCollectionsCompletion = (Result< [NftCollection], Error>) -> Void

//MARK: - NftCatalogServiceProtocol
protocol NftCatalogServiceProtocol {
    func loadNft(completion: @escaping NftCollectionsCompletion)
}

//MARK: - NftCatalogService
final class NftCatalogService: NftCatalogServiceProtocol {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
//    private let storage: CatalogStorageProtocol
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public methods
    func loadNft( completion: @escaping NftCollectionsCompletion) {
        let request = CollectionsRequest()
        networkClient.send(request: request, type: [NftCollection].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
