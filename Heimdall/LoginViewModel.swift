import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let email = PublishSubject<String?>()
        let password = PublishSubject<String?>()
    }

    struct Output {
        let emailValidation: Observable<String?>
        let isButtonEnabled: Observable<Bool>
    }

    let input = Input()
    let output: Output

    init() {
        output = Output(
            emailValidation: Transforms.emailValidation(email: input.email),
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

            return email.map(Mappings.toValidation(email:))
        }

        static func isButtonEnabled(
            email: Observable<String?>,
            password: Observable<String?>
        ) -> Observable<Bool> {

            return Observable
                .combineLatest(email, password)
                .map(Mappings.isButtonEnabled(email:password:))
                .startWith(false)
        }
    }

    struct Mappings {
        static func toValidation(email: String?) -> String? {
            if case .invalidFormat = Validations.validate(email: email) {
                return Strings.invalidEmailMessage
            } else {
                return nil
            }
        }

        static func isButtonEnabled(email: String?, password: String?) -> Bool {
            if let email = email, let password = password {
                return Validations.validate(email: email) == .ok
                    && Validations.validate(
                        password: password,
                        minimumLength: 5
                    )
            } else {
                return false
            }
        }
    }
}
