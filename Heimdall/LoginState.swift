enum LoginState {
    case idle
    case inProgress
    case successful
    case failed(Error)
}
