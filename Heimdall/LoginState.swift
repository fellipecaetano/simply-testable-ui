enum LoginState: Equatable {
    case idle
    case inProgress
    case successful
    case failed(Error)

    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, idle):
            return true
        case (.inProgress, .inProgress):
            return true
        case (.successful, .successful):
            return true
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
