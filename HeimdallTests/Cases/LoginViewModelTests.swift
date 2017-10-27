import XCTest
import Nimble
@testable import Heimdall

class LoginViewModelTests: XCTestCase {
    func testEmailValidationWithValidEmail() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext("john.doe@example.com")

        expect(observer.values.count) == 1
        expect(observer.values[0]).to(beNil())
    }

    func testEmailValidationWithBlankEmail() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext(" ")

        expect(observer.values.count) == 1
        expect(observer.values[0]).to(beNil())
    }

    func testEmailValidationWithInvalidEmail() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

        viewModel.input.email.onNext("john.doe@example")

        expect(observer.values.count) == 1
        expect(observer.values[0]) == Strings.invalidEmailMessage
    }

    func testPasswordValidationWithValidPassword() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext("admin123")

        expect(observer.values.count) == 1
        expect(observer.values[0]).to(beNil())
    }

    func testPasswordValidationWithBlankPassword() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext(" ")

        expect(observer.values.count) == 1
        expect(observer.values[0]).to(beNil())
    }

    func testPasswordValidationWithShortPassword() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

        viewModel.input.password.onNext("adm")

        expect(observer.values.count) == 1
        expect(observer.values[0]) == Strings.shortPasswordMessage(minimumLength: 5)
    }

    func testIfButtonIsEnabledWhenFormIsFilled() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, true]
    }

    func testIfButtonIsEnabledWhenEmailIsEmpty() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("  ")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledWhenPasswordIsEmpty() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("  ")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledInitially() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)
        expect(observer.values) == [false]
    }

    func testIfButtonIsEnabledWhenEmailIsInvalid() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example")
        viewModel.input.password.onNext("password")

        expect(observer.values) == [false, false]
    }

    func testIfButtonIsEnabledWhenPasswordIsTooShort() {
        let viewModel = LoginViewModel()
        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

        viewModel.input.email.onNext("john.doe@example.com")
        viewModel.input.password.onNext("pwd")

        expect(observer.values) == [false, false]
    }
}
