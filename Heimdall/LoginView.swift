import UIKit

final class LoginView: UIView {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailValidationLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordValidationLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
}
