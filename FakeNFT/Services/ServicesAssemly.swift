final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    var nftCatalogService: NftCatalogServiceProtocol
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.nftCatalogService =  NftCatalogService(
            networkClient: networkClient
        )
    }
}
