//
//  NftCollectionService.swift
//  FakeNFT
//
//  Created by Эмилия on 16.02.2024.
//

import Foundation

typealias NftCollectionCompletion = (Result<[NftCollection], Error>) -> Void

//MARK: - NftCollectionService
protocol NftCollectionService {
    func loadNft(completion: @escaping NftCollectionCompletion)
}

//MARK: - NftCollectionServiceImpl
final class NftCollectionServiceImpl: NftCollectionService {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - Methods
    func loadNft(completion: @escaping NftCollectionCompletion) {
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
