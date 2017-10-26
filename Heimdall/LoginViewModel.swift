import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let email = PublishSubject<String?>()
        let password = PublishSubject<String?>()
    }

    struct Output {
        let isButtonEnabled: Observable<Bool>
    }

    let input = Input()
    let output: Output

    init() {
        output = Output(
            isButtonEnabled: Transforms.isButtonEnabled(
                email: input.email,
                password: input.password
            )
        )
    }
}

private extension LoginViewModel {
    struct Transforms {
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
        static func isButtonEnabled(email: String?, password: String?) -> Bool {
            if let email = email, let password = password {
                return Validations.validate(email: email)
                    && Validations.validate(password: password, minimumLength: 5)
            } else {
                return false
            }
        }
    }
}
