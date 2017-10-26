import Foundation

struct Validations {
    static func validate(email: String?) -> Bool {
        let predicate = NSPredicate(format: "SELF matches %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")

        if let email = email {
            return !email.trimmingCharacters(in: .whitespaces).isEmpty
                && predicate.evaluate(with: email)
        } else {
            return false
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
