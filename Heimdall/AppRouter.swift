import UIKit
import RxSwift

final class AppRouter {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let navigationController = UINavigationController()
    private var initialViewController: LoginViewController!
    private let loginInterpreter = LoginInterpreter()
    private let disposeBag = DisposeBag()

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showInitialViewController()
        setUpBindings()
    }

    private func showInitialViewController() {
        let viewModel = LoginViewModel(state: loginInterpreter.rx.state)
        initialViewController = LoginViewController(viewModel: viewModel)
        initialViewController.title = Strings.loginTitle
        navigationController.pushViewController(initialViewController, animated: false)
    }

    private func setUpBindings() {
        initialViewController.rx
            .action
            .bind(to: loginInterpreter)
            .disposed(by: disposeBag)

        initialViewController.rx
            .action
            .subscribe(onNext: { [unowned self] action in
                self.route(action: action)
            })
            .disposed(by: disposeBag)
    }

    private func route(action: LoginAction) {
        switch action {
        case .acknowledgeSuccess: acknowledgeSuccessfulLogin()
        default: break
        }
    }

    private func acknowledgeSuccessfulLogin() {
        let alert = LoginSuccessAlertController()
        alert.present(in: initialViewController)
    }
}
