import XCTest
import Nimble
@testable import Heimdall

class LoginViewModelTests: XCTestCase {
    func testEmailValidationWithValidEmail() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext("john.doe@example.com")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testEmailValidationWithBlankEmail() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext(" ")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testEmailValidationWithInvalidEmail() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext("john.doe@example")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })) == [Strings.invalidEmailMessage]
    }

    func testEmailValidationWhenCredentialsAreInvalid() {
        let state = LoginState.failed(LoginError.invalidCredentials)
        let viewModel = LoginViewModel(state: .just(state))
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)
        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })) == [Strings.invalidCredentialsMessage]
    }

    func testEmailValidationWhenErrorsAreGeneral() {
        let state = [LoginError.badRequest, .generalFailure].map(LoginState.failed)
        let viewModel = LoginViewModel(state: .from(state))
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)
        expect(observer.values.count) == state.count
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testPasswordValidationWithValidPassword() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext("password")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testPasswordValidationWithBlankPassword() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext(" ")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testPasswordValidationWithShortPassword() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext("pwd")

        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })) == [Strings.shortPasswordMessage(minimumLength: 5)]
    }

    func testPasswordValidationWhenCredentialsAreInvalid() {
        let state = LoginState.failed(LoginError.invalidCredentials)
        let viewModel = LoginViewModel(state: .just(state))
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)
        expect(observer.values.count) == 1
        expect(observer.values.flatMap({ $0 })) == [Strings.invalidCredentialsMessage]
    }

    func testPasswordValidationWhenErrorsAreGeneral() {
        let state = [LoginError.badRequest, .generalFailure].map(LoginState.failed)
        let viewModel = LoginViewModel(state: .from(state))
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)
        expect(observer.values.count) == state.count
        expect(observer.values.flatMap({ $0 })).to(beEmpty())
    }

    func testIfButtonIsEnabledWhenFormIsFilled() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, true]
    }

    func testIfButtonIsEnabledWhenEmailIsEmpty() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("  ")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledWhenPasswordIsEmpty() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("  ")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledInitially() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)
        expect(observer.values) == [false]
    }

    func testIfButtonIsEnabledWhenEmailIsInvalid() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledWhenPasswordIsTooShort() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("pwd")

        expect(observer.values) == [false, false]
    }

    func testIfActivityIndicatorIsAnimating() {
        let state = [
            LoginState.idle,
            .inProgress,
            .failed(LoginError.badRequest),
            .successful
        ]

        let viewModel = LoginViewModel(state: .from(state))
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isActivityIndicatorAnimating)
        expect(observer.values) == [false, true, false, false]
    }

    func testActionWhenButtonIsTapped() {
        let viewModel = LoginViewModel(state: .empty())
        let observer = TestObserver<LoginAction>.bound(to: viewModel.output.action)
        let email = "john.doe@example"
        let password = "password"

        viewModel.input.email.onNext(email)
        viewModel.input.password.onNext(password)
        viewModel.input.buttonTap.onNext(())

        expect(observer.values) == [
            LoginAction.login(email: email, password: password)
        ]
    }
}
