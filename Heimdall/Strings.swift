struct Strings {
    static let invalidEmailMessage = "This e-mail address has an invalid format"

    static func shortPasswordMessage(minimumLength: Int) -> String {
        return "This password has less than \(minimumLength) characters"
    }
}
