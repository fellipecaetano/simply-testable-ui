import Nimble
import Quick
import RxSwift
@testable import Heimdall

class LoginViewModelSpec: QuickSpec {
    override func spec() {
        describe("the login UI's view model") {
            describe("its e-mail validation") {
                context("when the e-mail is valid") {
                    it("emits an empty validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

                        viewModel.input.email.onNext("john.doe@example.com")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }

                context("when the e-mail is blank") {
                    it("emits an empty validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

                        viewModel.input.email.onNext(" ")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }

                context("when the e-mail has an invalid format") {
                    it("emits an invalid e-mail format validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)

                        viewModel.input.email.onNext("john.doe@example")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })) == [Strings.invalidEmailMessage]
                    }
                }

                context("when the state indicates the credentials were rejected") {
                    it("emits an invalid credentials validation message") {
                        let state = LoginState.failed(LoginError.invalidCredentials)
                        let viewModel = LoginViewModel(state: .just(state))
                        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)
                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })) == [Strings.invalidCredentialsMessage]
                    }
                }

                context("when the state indicates a general or unknown failure") {
                    it("emits an empty validation message") {
                        let state = [LoginError.badRequest, .generalFailure].map(LoginState.failed)
                        let viewModel = LoginViewModel(state: .from(state))
                        let observer = TestObserver<String?>.bound(to: viewModel.output.emailValidation)
                        expect(observer.values.count) == state.count
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }
            }

            describe("its password validation") {
                context("when the password is valid") {
                    it("emits an empty validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

                        viewModel.input.password.onNext("password")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }

                context("when the password is blank") {
                    it("emits an empty validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

                        viewModel.input.password.onNext(" ")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }

                context("when the password is shorter than the minimum length") {
                    it("emits a short passsword validation message") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)

                        viewModel.input.password.onNext("pwd")

                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })) == [Strings.shortPasswordMessage(minimumLength: 5)]
                    }
                }
                context("when the state indicates the credentials were rejected") {
                    it("emits an invalid credentials validation message") {
                        let state = LoginState.failed(LoginError.invalidCredentials)
                        let viewModel = LoginViewModel(state: .just(state))
                        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)
                        expect(observer.values.count) == 1
                        expect(observer.values.flatMap({ $0 })) == [Strings.invalidCredentialsMessage]
                    }
                }

                context("when the state indicates a general or unknown failure") {
                    it("emits an empty validation message") {
                        let state = [LoginError.badRequest, .generalFailure].map(LoginState.failed)
                        let viewModel = LoginViewModel(state: .from(state))
                        let observer = TestObserver<String?>.bound(to: viewModel.output.passwordValidation)
                        expect(observer.values.count) == state.count
                        expect(observer.values.flatMap({ $0 })).to(beEmpty())
                    }
                }
            }

            describe("the login button") {
                it("is initially enabled") {
                    let viewModel = LoginViewModel(state: .empty())
                    let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)
                    expect(observer.values) == [false]
                }

                context("when all form fields are filled") {
                    it("it is enabled") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

                        viewModel.input.email.onNext("john.doe@example.com")
                        viewModel.input.password.onNext("password")

                        expect(observer.values.last) == true
                    }
                }

                context("when the e-mail is blank") {
                    it("is not enabled") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

                        viewModel.input.email.onNext("  ")
                        viewModel.input.password.onNext("password")

                        expect(observer.values.last) == false
                    }
                }

                context("when the password is blank") {
                    it("is not enabled") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

                        viewModel.input.email.onNext("john.doe@example.com")
                        viewModel.input.password.onNext("  ")

                        expect(observer.values.last) == false
                    }
                }

                context("when the e-mail has an invalid format") {
                    it("is not enabled") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

                        viewModel.input.email.onNext("john.doe@example")
                        viewModel.input.password.onNext("password")

                        expect(observer.values.last) == false
                    }
                }

                context("when the password is shorter than the minimum length") {
                    it("is not enabled") {
                        let viewModel = LoginViewModel(state: .empty())
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isButtonEnabled)

                        viewModel.input.email.onNext("john.doe@example")
                        viewModel.input.password.onNext("pwd")

                        expect(observer.values.last) == false
                    }
                }

                context("when it is tapped") {
                    it("emits a login action") {
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
            }

            describe("the activity indicator") {
                context("when the state indicates the UI is idle") {
                    it("does not animate") {
                        let viewModel = LoginViewModel(state: .just(.idle))
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isActivityIndicatorAnimating)
                        expect(observer.values) == [false]
                    }
                }

                context("when the state indicates login is in progress") {
                    it("animates") {
                        let viewModel = LoginViewModel(state: .just(.inProgress))
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isActivityIndicatorAnimating)
                        expect(observer.values) == [true]
                    }
                }

                context("when the state indicates failure") {
                    it("does not animate") {
                        let viewModel = LoginViewModel(state: .just(.failed(LoginError.badRequest)))
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isActivityIndicatorAnimating)
                        expect(observer.values) == [false]
                    }
                }

                context("when the state indicates success") {
                    it("does not animate") {
                        let viewModel = LoginViewModel(state: .just(.successful))
                        let observer = TestObserver<Bool>.bound(to: viewModel.output.isActivityIndicatorAnimating)
                        expect(observer.values) == [false]
                    }
                }
            }
        }
    }
}
