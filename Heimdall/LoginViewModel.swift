import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
    }

    struct Output {
        let isButtonEnabled: Driver<Bool>
    }

    let input = Input()
    let output: Output

    init() {
        output = Output(
            isButtonEnabled: Transforms.isButtonEnabled()
        )
    }
}

private extension LoginViewModel {
    struct Transforms {
        static func isButtonEnabled() -> Driver<Bool> {
            return .empty()
        }
    }
}
