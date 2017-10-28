import RxSwift
import RxCocoa

final class LoginInterpreter: ObserverType {
    fileprivate let stateSubject = BehaviorSubject<LoginState>(value: .idle)
    private var session: URLSession?
    private let disposeBag = DisposeBag()

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

        session!.rx
            .response(request: request)
            .map(toState(response:data:))
            .startWith(.inProgress)
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base == LoginInterpreter {
    var state: Observable<LoginState> {
        return base.stateSubject
    }
}

private func toState(response: HTTPURLResponse, data _: Data) -> LoginState {
    if response.statusCode == 401 {
        return .failed(LoginError.invalidCredentials)
    } else if response.statusCode == 400 {
        return .failed(LoginError.badRequest)
    } else if (200 ..< 300) ~= response.statusCode {
        return .successful
    } else {
        return .failed(LoginError.generalFailure)
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
