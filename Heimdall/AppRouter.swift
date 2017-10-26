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
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.title = "Login"
        navigationController.pushViewController(viewController, animated: false)
    }
}
