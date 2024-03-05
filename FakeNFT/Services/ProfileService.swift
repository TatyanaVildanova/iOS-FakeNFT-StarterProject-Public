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
    func likeState(for id:String) -> Bool
    func setLike(id: String, completion: @escaping ProfileCompletion)
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
        loadLikes { _ in }
    }
    
    // MARK: - Methods
    func loadLikes(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                profile.likes.forEach {
                    storage?.saveLike($0)
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
    
    func setLike(id: String, completion: @escaping ProfileCompletion) {
        var likes = storage.likes
        if let _ = storage.getLike(with: id) {
            likes.remove(id)
        } else {
            likes.insert(id)
        }
        
        let request = LikeRequest(likes: likes)
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.likes.removeAll()
                profile.likes.forEach {
                    storage?.saveLike($0)
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
