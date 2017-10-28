import UIKit

final class AppRouter {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let navigationController = UINavigationController()
    private let loginInterpreter = LoginInterpreter()

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showInitialViewController()
    }

    private func showInitialViewController() {
        let viewModel = LoginViewModel(state: loginInterpreter.rx.state)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.title = "Login"
        _ = viewController.rx.action.bind(to: loginInterpreter)
        navigationController.pushViewController(viewController, animated: false)
    }
}
