import Foundation

struct Validations {
    static func validate(email: String?) -> EmailValidation {
        let predicate = NSPredicate(
            format: "SELF matches %@",
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        )

        if let email = email, email.trimmingCharacters(in: .whitespaces).isEmpty {
            return .blank
        } else if let email = email, !predicate.evaluate(with: email) {
            return .invalidFormat
        } else if email != nil {
            return .ok
        } else {
            return .blank
        }
    }

    static func validate(password: String?, minimumLength: Int) -> Bool {
        if let password = password {
            return password.trimmingCharacters(in: .whitespaces).count >= minimumLength
        } else {
            return false
        }
    }
}

enum EmailValidation {
    case ok
    case blank
    case invalidFormat
}
