import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let router = AppRouter()

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        router.start()
        return true
    }
}
