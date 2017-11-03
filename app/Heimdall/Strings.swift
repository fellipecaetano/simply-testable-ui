struct Strings {
    static let loginTitle = "Login"

    static let invalidEmailMessage = "This e-mail address has an invalid format"

    static func shortPasswordMessage(minimumLength: Int) -> String {
        return "This password has less than \(minimumLength) characters"
    }

    static let invalidCredentialsMessage
        = "No user corresponds to these credentials"

    static let successfulLoginAlertTitle = "Congratulations!"

    static let successfulLoginAlertMessage = "\nYou're in 💃"

    static let successfulLoginAlertButton = "OK"
}
