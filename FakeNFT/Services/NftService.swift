import Foundation

typealias NftCompletion = (Result<Nft, Error>) -> Void

//MARK: - NftService
protocol NftService {
    func loadNft(id: String, completion: @escaping NftCompletion)
}

//MARK: - NftServiceImpl
final class NftServiceImpl: NftService {

    //MARK: - Private properties
    private let networkClient: NetworkClient
    private let storage: NftStorage

    // MARK: - Initializers
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    // MARK: - Methods
    func loadNft(id: String, completion: @escaping NftCompletion) {
        if let nft = storage.getNft(with: id) {
            completion(.success(nft))
            return
        }
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self) { [weak storage] result in
            switch result {
            case .success(let nft):
                storage?.saveNft(nft)
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
