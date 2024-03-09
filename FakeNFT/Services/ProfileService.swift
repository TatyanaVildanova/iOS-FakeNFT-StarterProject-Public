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
    func loadLikes(completion: @escaping ProfileCompletion)
    func setLike(id: String, likes: [String], completion: @escaping ProfileCompletion)
}

//MARK: - ProfileServiceImpl
final class ProfileServiceImpl: ProfileService {
    
    //MARK: - Private properties
    private let networkClient: NetworkClient
    
    // MARK: - Initializers
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        loadLikes { _ in }
    }
    
    // MARK: - Methods
    func loadLikes(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setLike(id: String, likes: [String], completion: @escaping ProfileCompletion) {
        let request = LikeRequest(likes: likes)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
