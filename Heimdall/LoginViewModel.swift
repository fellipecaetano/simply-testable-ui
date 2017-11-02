import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let email = PublishSubject<String?>()
        let password = PublishSubject<String?>()
        let buttonTap = PublishSubject<Void>()
    }

    struct Output {
        let emailValidation: Observable<String?>
        let passwordValidation: Observable<String?>
        let isButtonEnabled: Observable<Bool>
        let isActivityIndicatorAnimating: Observable<Bool>
        let action: Observable<LoginAction>
    }

    let input = Input()
    let output: Output

    init(state: Observable<LoginState>) {
        output = Output(
            emailValidation: Transforms.emailValidation(
                state: state,
                email: input.email
            ),
            passwordValidation: Transforms.passwordValidation(
                state: state,
                password: input.password
            ),
            isButtonEnabled: Transforms.isButtonEnabled(
                email: input.email,
                password: input.password
            ),
            isActivityIndicatorAnimating: Transforms.isActivityIndicatorAnimating(
                state: state
            ),
            action: Transforms.action(
                state: state,
                buttonTap: input.buttonTap,
                email: input.email,
                password: input.password
            )
        )
    }

    init(output: Output) {
        self.output = output
    }
}

private extension LoginViewModel {
    struct Transforms {
        static func emailValidation(
            state: Observable<LoginState>,
            email: Observable<String?>
        ) -> Observable<String?> {

            let offlineValidation = email.map({ email -> String? in
                switch Validations.validate(email: email) {
                case .invalidFormat:
                    return Strings.invalidEmailMessage
                default:
                    return nil
                }
            })

            let stateValidation = state.map({ state -> String? in
                switch state {
                case .failed(LoginError.invalidCredentials):
                    return Strings.invalidCredentialsMessage
                default:
                    return nil
                }
            })

            return Observable.merge(offlineValidation, stateValidation)
        }

        static func passwordValidation(
            state: Observable<LoginState>,
            password: Observable<String?>
        ) -> Observable<String?> {

            let offlineValidation = password.map({ password -> String? in
                switch Validations.validate(password: password) {
                case let .short(minimumLength):
                    return Strings.shortPasswordMessage(minimumLength: minimumLength)
                default:
                    return nil
                }
            })

            let stateValidation = state.map({ state -> String? in
                switch state {
                case .failed(LoginError.invalidCredentials):
                    return Strings.invalidCredentialsMessage
                default:
                    return nil
                }
            })

            return Observable.merge(offlineValidation, stateValidation)
        }

        static func isButtonEnabled(
            email: Observable<String?>,
            password: Observable<String?>
        ) -> Observable<Bool> {

            return Observable
                .combineLatest(email, password)
                .map({ email, password in
                    if let email = email, let password = password {
                        return Validations.validate(email: email) == .ok
                            && Validations.validate(password: password) == .ok
                    } else {
                        return false
                    }
                })
                .startWith(false)
        }

        static func isActivityIndicatorAnimating(
            state: Observable<LoginState>
        ) -> Observable<Bool> {

            return state.map({ $0 == .inProgress })
        }

        static func action(
            state: Observable<LoginState>,
            buttonTap: Observable<Void>,
            email: Observable<String?>,
            password: Observable<String?>
        ) -> Observable<LoginAction> {

            let login = buttonTap
                .withLatestFrom(
                    Observable.combineLatest(email, password)
                )
                .map({ email, password in
                    LoginAction.login(email: email, password: password)
                })

            let successAcknowledgement = state
                .filter({ $0 == .successful })
                .map({ _ in LoginAction.acknowledgeSuccess })

            return Observable.merge(login, successAcknowledgement)
        }
    }
}
