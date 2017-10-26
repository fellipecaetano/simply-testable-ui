import RxSwift
import RxCocoa

final class TestObserver<T>: ObserverType {
    typealias E = T

    private var events = [Event<T>]()

    var values: [T] {
        return events.flatMap({ $0.element })
    }

    private init() {}

    func on(_ event: Event<T>) {
        events.append(event)
    }
}

extension TestObserver {
    static func bound(to observable: Observable<T>) -> TestObserver<T> {
        let observer = TestObserver()
        _ = observable.bind(to: observer)
        return observer
    }
}
