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
            state _: Observable<LoginState>,
            email _: Observable<String?>
        ) -> Observable<String?> {

            // TODO: complete
            return .empty()
        }

        static func passwordValidation(
            state _: Observable<LoginState>,
            password _: Observable<String?>
        ) -> Observable<String?> {

            // TODO: complete
            return .empty()
        }

        static func isButtonEnabled(
            email _: Observable<String?>,
            password _: Observable<String?>
        ) -> Observable<Bool> {

            // TODO: complete
            return .empty()
        }

        static func isActivityIndicatorAnimating(
            state _: Observable<LoginState>
        ) -> Observable<Bool> {

            // TODO: complete
            return .empty()
        }

        static func action(
            state _: Observable<LoginState>,
            buttonTap _: Observable<Void>,
            email _: Observable<String?>,
            password _: Observable<String?>
        ) -> Observable<LoginAction> {

            // TODO: complete
            return .empty()
        }
    }
}
