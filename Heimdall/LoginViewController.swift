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
    fileprivate let viewModel: LoginViewModel

    // State
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
        setUpBindings()
    }

    private func setUpBindings() {
        // TODO: complete
    }
}

extension Reactive where Base == LoginViewController {
    var action: Observable<LoginAction> {
        return base.viewModel.output.action
    }
}
