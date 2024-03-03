import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Public Properties
    var window: UIWindow?
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl(),
        profileStorage: ProfileStorage()
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let viewController = TabBarController(servicesAssembly: servicesAssembly)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}
