enum LoginAction: Equatable {
    case login(email: String?, password: String?)
    case acknowledgeSuccess

    static func == (lhs: LoginAction, rhs: LoginAction) -> Bool {
        switch (lhs, rhs) {
        case let (
            .login(lhsEmail, lhsPassword),
            .login(rhsEmail, rhsPassword)
        ):

            return lhsEmail == rhsEmail
                && lhsPassword == rhsPassword

        case (.acknowledgeSuccess, .acknowledgeSuccess):
            return true

        default:
            return false
        }
    }
}
