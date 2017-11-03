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

    static func validate(password: String?) -> PasswordValidation {
        if let password = password,
            password.trimmingCharacters(in: .whitespaces).isEmpty {

            return .blank
        } else if let password = password,
            password.trimmingCharacters(in: .whitespaces).count < minimumLength {

            return .short(minimumLength: minimumLength)
        } else if password != nil {
            return .ok
        } else {
            return .blank
        }
    }

    private static let minimumLength = 5
}

enum EmailValidation {
    case ok
    case blank
    case invalidFormat
}

enum PasswordValidation: Equatable {
    case ok
    case blank
    case short(minimumLength: Int)

    static func == (lhs: PasswordValidation, rhs: PasswordValidation) -> Bool {
        switch (lhs, rhs) {
        case (.ok, .ok):
            return true
        case (.blank, .blank):
            return true
        case let (.short(lhsLength), .short(rhsLength)):
            return lhsLength == rhsLength
        default:
            return false
        }
    }
}
