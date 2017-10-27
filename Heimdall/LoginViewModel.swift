import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let email = PublishSubject<String?>()
        let password = PublishSubject<String?>()
    }

    struct Output {
        let emailValidation: Observable<String?>
        let passwordValidation: Observable<String?>
        let isButtonEnabled: Observable<Bool>
    }

    let input = Input()
    let output: Output

    init() {
        output = Output(
            emailValidation: Transforms.emailValidation(email: input.email),
            passwordValidation: Transforms.passwordValidation(password: input.password),
            isButtonEnabled: Transforms.isButtonEnabled(
                email: input.email,
                password: input.password
            )
        )
    }
}

private extension LoginViewModel {
    struct Transforms {
        static func emailValidation(
            email: Observable<String?>
        ) -> Observable<String?> {

            return email.map({ email in
                switch Validations.validate(email: email) {
                case .invalidFormat:
                    return Strings.invalidEmailMessage
                default:
                    return nil
                }
            })
        }

        static func passwordValidation(
            password: Observable<String?>
        ) -> Observable<String?> {

            return password.map({ password in
                switch Validations.validate(password: password) {
                case .short(let minimumLength):
                    return Strings.shortPasswordMessage(minimumLength: minimumLength)
                default:
                    return nil
                }
            })
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
    }
}
