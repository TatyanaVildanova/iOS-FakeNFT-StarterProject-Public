import Foundation

//MARK: - NftStorage
protocol NftStorage: AnyObject {
    var likes: Set<String> { get set }
    var orders: Set<String> { get set }
    var orderId: String? { get }
    func saveNft(_ nft: Nft)
    func getNft(with id: String) -> Nft?
    func getLike(with id: String) -> String?
    func saveLike(_ nft: String)
    func deleteLike(with id: String)
    func saveOrderId(orderId: String)
    func saveOrders(_ nft: String)
    func findInOrders(_ nft: String)-> Bool
    func deleteOrders(with id: String)
}

//MARK: - NftStorageImpl
final class NftStorageImpl: NftStorage {
    
    //MARK: - Properties
    var likes: Set<String> = []
    var orders: Set<String> = []
    var orderId: String?
    
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
    
    //MARK: - Like methods
    func getLike(with id: String) -> String? {
        return syncQueue.sync {
            likes.first(where: {$0 == id})
        }
    }
    
    func saveLike(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }
    
    func deleteLike(with id: String) {
        syncQueue.async { [weak self] in
            self?.likes.remove(id)
        }
    }
    
    //MARK: - Order methods
    func saveOrderId(orderId: String){
        syncQueue.async { [weak self] in
            self?.orderId = orderId
        }
    }
    
    func saveOrders(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.orders.insert(nft)
        }
    }
    
    func findInOrders(_ nft: String) -> Bool {
        orders.contains(nft)
    }
    
    func deleteOrders(with id: String) {
        syncQueue.async { [weak self] in
            self?.orders.remove(id)
        }
    }
}
