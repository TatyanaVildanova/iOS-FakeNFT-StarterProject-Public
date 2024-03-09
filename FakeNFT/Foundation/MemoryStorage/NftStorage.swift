import Foundation

//MARK: - NftStorage
protocol NftStorage: AnyObject {
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
}

//MARK: - NftStorageImpl
final class NftStorageImpl: NftStorage {
    
    //MARK: - Private properties
    private var storage: [String: Nft] = [:]
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")
    
    //MARK: - Nft methods
    func saveNft(_ nft: Nft) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }
    
    func getNft(with id: String) -> Nft? {
        syncQueue.sync {
            storage[id]
        }
    }
}
