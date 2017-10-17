import UIKit

final class AppRouter {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let navigationController = UINavigationController()

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showInitialViewController()
    }

    private func showInitialViewController() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .blue
        navigationController.pushViewController(viewController, animated: false)
    }
}
