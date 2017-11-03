import UIKit

final class LoginSuccessAlertController {
    private let title = Strings.successfulLoginAlertTitle
    private let message = Strings.successfulLoginAlertMessage
    private let button = Strings.successfulLoginAlertButton

    func present(in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default, handler: nil))
        viewController.present(alert, animated: true)
    }
}
