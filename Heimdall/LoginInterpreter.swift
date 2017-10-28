import RxSwift
import RxCocoa

final class LoginInterpreter: ObserverType {
    fileprivate let stateSubject = BehaviorRelay<LoginState>(value: .idle)
    private var session: URLSession?

    func on(_ event: Event<LoginAction>) {
        switch event {
        case .next(let action):
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
        session = URLSession(configuration: .default)

        let url = URL(string: "https://heimdall-app.herokuapp.com/sessions")!
        let body = toBody(email: email, password: password)
        let request = toRequest(url: url)(body)

        stateSubject.accept(.inProgress)

        session!.rx
            .response(request: request)
            .observeOn(MainScheduler.asyncInstance)
    }
}

extension Reactive where Base == LoginInterpreter {
    var state: Observable<LoginState> {
        return base.stateSubject.asObservable()
    }
}

private func toBody(email: String?, password: String?) -> [String: String] {
    guard let email = email, let password = password else {
        return [:]
    }

    return ["email": email, "password": password]
}

private func toRequest(url: URL) -> ([String: String]) -> URLRequest {
    return { body in
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        return request
    }
}
