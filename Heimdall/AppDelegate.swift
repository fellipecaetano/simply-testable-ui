import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = UIViewController()
        window?.rootViewController?.view.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }
}
