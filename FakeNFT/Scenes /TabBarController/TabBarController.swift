import UIKit

final class TabBarController: UITabBarController {
    
    var servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "YP Catalog"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let navController = UINavigationController(rootViewController: catalogController)
        
        catalogController.tabBarItem = catalogTabBarItem
        viewControllers = [navController]
        view.backgroundColor = .systemBackground
    }
}
