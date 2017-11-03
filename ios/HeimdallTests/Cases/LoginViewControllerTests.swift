import FBSnapshotTestCase
@testable import Heimdall

class LoginViewControllerTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
        isDeviceAgnostic = true
    }

    func testDisabledButton() {
        let viewModel = LoginViewModel(
            output: LoginViewModel.Output(
                emailValidation: .empty(),
                passwordValidation: .empty(),
                isButtonEnabled: .just(false),
                isActivityIndicatorAnimating: .empty(),
                action: .empty()
            )
        )

        let viewController = LoginViewController(viewModel: viewModel)
        FBSnapshotVerifyView(viewController.view)
    }

    func testAnimatedActivityIndicator() {
        let viewModel = LoginViewModel(
            output: LoginViewModel.Output(
                emailValidation: .empty(),
                passwordValidation: .empty(),
                isButtonEnabled: .empty(),
                isActivityIndicatorAnimating: .just(true),
                action: .empty()
            )
        )

        let viewController = LoginViewController(viewModel: viewModel)
        FBSnapshotVerifyView(viewController.view)
    }

    func testFieldValidations() {
        let viewModel = LoginViewModel(
            output: LoginViewModel.Output(
                emailValidation: .just("E-mail validation message"),
                passwordValidation: .just("Password validation message"),
                isButtonEnabled: .empty(),
                isActivityIndicatorAnimating: .just(true),
                action: .empty()
            )
        )

        let viewController = LoginViewController(viewModel: viewModel)
        FBSnapshotVerifyView(viewController.view)
    }
}
