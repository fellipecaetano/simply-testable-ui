import XCTest
import Nimble
@testable import Heimdall

class LoginViewModelTests: XCTestCase {
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
