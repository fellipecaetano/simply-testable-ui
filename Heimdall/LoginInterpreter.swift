import RxSwift
import RxCocoa

final class LoginInterpreter: ObserverType, ReactiveCompatible {
    fileprivate let stateRelay = BehaviorRelay<LoginState>(value: .idle)
    private let service = LoginService()
    private let disposeBag = DisposeBag()

    func on(_ event: Event<LoginAction>) {
        switch event {
        case let .next(action):
            interpret(action: action)
        default:
            break
        }
    }

    private func interpret(action: LoginAction) {
        switch action {
        case let .login(email, password):
            login(email: email, password: password)
        }
    }

    private func login(email: String?, password: String?) {
        stateRelay.accept(.inProgress)

        service
            .login(email: email, password: password)
            .subscribe(onSuccess: { [unowned self] in
                self.stateRelay.accept(.successful)
            }, onError: { [unowned self] error in
                self.stateRelay.accept(.failed(error))
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == LoginInterpreter {
    var state: Observable<LoginState> {
        return base.stateRelay.asObservable()
    }
}
