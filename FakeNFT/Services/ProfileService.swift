import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(id: String, completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient

    private let profileStorage: ProfileStorage
    
    init(networkClient: NetworkClient, profileStorage: ProfileStorage) {
        self.networkClient = networkClient
        self.profileStorage = profileStorage
    }
    
    func loadProfile(id: String, completion: @escaping ProfileCompletion) {
        if let profile = profileStorage.getProfile(with: id) {
            completion(.success(profile))
            return
        }

        let request = ProfileRequest(id: id)
        networkClient.send(request: request, type: Profile.self) { [weak profileStorage] result in
            switch result {
            case .success(let profile):
                profileStorage?.saveProfile(profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
