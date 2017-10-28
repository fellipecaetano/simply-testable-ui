import RxSwift

final class LoginService {
    private var session: URLSession?

    func login(email: String?, password: String?) -> Single<()> {
        session = URLSession(configuration: .default)

        let url = URL(string: "https://heimdall-app.herokuapp.com/sessions")!
        let params = toParams(email: email, password: password)
        let request = toRequest(url: url, params: params)

        return .create { [unowned self] observer in
            let disposable = self.session!.rx
                .response(request: request)
                .subscribe(onNext: { response, _ in
                    observer(toEvent(response: response))
                })

            return disposable
        }
    }
}

private func toParams(email: String?, password: String?) -> [String: String] {
    guard let email = email, let password = password else {
        return [:]
    }

    return ["email": email, "password": password]
}

private func toRequest(url: URL, params: [String: String]) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    return request
}

private func toEvent(response: HTTPURLResponse) -> SingleEvent<()> {
    if response.statusCode == 401 {
        return .error(LoginError.invalidCredentials)
    } else if response.statusCode == 400 {
        return .error(LoginError.badRequest)
    } else if (200 ..< 300) ~= response.statusCode {
        return .success(())
    } else {
        return .error(LoginError.generalFailure)
    }
}
