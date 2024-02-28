//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Эмилия on 28.02.2024.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

//MARK: - ProfileService
protocol ProfileService {
    func loadProfile( completion: @escaping ProfileCompletion)
    func likeState(for id:String) -> Bool
}

//MARK: - ProfileServiceImpl
final class ProfileServiceImpl: ProfileService {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    // MARK: - Initializers
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
        loadProfile { _ in }
    }
    
    // MARK: - Methods
    func loadProfile( completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak self] result in
            switch result {
            case .success(let profile):
                profile.likes.forEach {
                    self?.storage.saveLike($0)
                }
                
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func likeState(for id: String) -> Bool {
        storage.getLike(with: id) != nil
    }
}
