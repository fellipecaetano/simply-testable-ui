import UIKit

final class LoginViewController: UIViewController {
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
