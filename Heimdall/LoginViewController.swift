import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // Dependencies
    private let viewModel: LoginViewModel

    // State
    private var session: URLSession!
    private let requests = PublishSubject<URLRequest>()
    private let disposeBag = DisposeBag()

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        session = URLSession(configuration: .default)
        let url = URL(string: "https://heimdall-app.herokuapp.com/sessions")!

        button.rx
            .tap
            .subscribe(onNext: { [unowned self] in
                self.activityIndicator.startAnimating()
            })
            .disposed(by: disposeBag)

        button.rx
            .tap
            .withLatestFrom(
                Observable.combineLatest(
                    emailTextField.rx.text,
                    passwordTextField.rx.text
                )
            )
            .map(toBody(email:password:))
            .filter({ $0 != nil })
            .map({ $0! })
            .map(toRequest(url: url))
            .bind(to: requests)
            .disposed(by: disposeBag)

        requests
            .flatMap({ [unowned self] request in
                self.session.rx
                    .json(request: request)
                    .observeOn(MainScheduler.asyncInstance)
                    .catchErrorJustReturn(1)
            })
            .subscribe(onNext: { [unowned self] _ in
                self.activityIndicator.stopAnimating()
            }, onError: { [unowned self] _ in
                self.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)

        emailTextField.rx
            .text
            .bind(to: viewModel.input.email)
            .disposed(by: disposeBag)

        passwordTextField.rx
            .text
            .bind(to: viewModel.input.password)
            .disposed(by: disposeBag)

        viewModel.output
            .emailValidation
            .bind(to: emailValidationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.output
            .isButtonEnabled
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

private func toBody(email: String?, password: String?) -> [String: String]? {
    guard let email = email, let password = password else {
        return nil
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
