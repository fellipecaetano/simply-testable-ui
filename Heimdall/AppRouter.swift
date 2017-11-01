import UIKit

final class AppRouter {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let navigationController = UINavigationController()
    private var initialViewController: LoginViewController!
    private let loginInterpreter = LoginInterpreter()

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        setUpBindings()
        showInitialViewController()
    }

    private func setUpBindings() {
        let viewModel = LoginViewModel(state: loginInterpreter.rx.state)
        initialViewController = LoginViewController(viewModel: viewModel)
        initialViewController.title = "Login"
        _ = initialViewController.rx.action.bind(to: loginInterpreter)
    }

    private func showInitialViewController() {
        navigationController.pushViewController(initialViewController, animated: false)
    }
}
