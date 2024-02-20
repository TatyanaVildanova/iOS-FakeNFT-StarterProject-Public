import UIKit

// MARK: SceneDelegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: Public Properties
    var window: UIWindow?
    
    // MARK: Public Methods
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let viewController = TabBarController()
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

// MARK: UINavigationController
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.tintColor = UIColor(named: "YP Black")
    }
}
