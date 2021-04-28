import UIKit
import PromiseKit
class RootViewController: BaseViewController {
    static let shared = RootViewController()
    
    private(set) var rootViewController = UIViewController()
    
    var home: HomeTabbarViewController? {
        return rootViewController as? HomeTabbarViewController
    }
    weak var splashViewController: BaseViewController?
    
    private init() {
        super.init(nibName: nil, bundle: nil)
        LoginManager.shared.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @discardableResult
    func showHome(fromSplash splash: Bool = false) -> Promise<UIViewController> {
        if let window = UIApplication.shared.keyWindow {
            window.windowLevel = UIWindow.Level.normal
        }
        dismiss(animated: false)
        let source = rootViewController
        let destination = defaultNavigationController(root: HomeTabbarViewController(), isNavigationBarHidden: true)
        
        if splash {
            return transitFromSplash(to: destination)
        } else {
            return transit(from: source, to: destination)
        }
    }
    
    @discardableResult
    func showForceReivisePW() -> Promise<UIViewController> {
        if let window = UIApplication.shared.keyWindow {
            window.windowLevel = UIWindow.Level.normal
        }
        dismiss(animated: false)
        let source = rootViewController
        let destination = defaultNavigationController(root:RevisePWViewController(), isNavigationBarHidden: false)
        return transit(from: source, to: destination)
    }
    
    @discardableResult
    func showLogin(fromSplash splash: Bool = false) -> Promise<UIViewController> {
        if let window = UIApplication.shared.keyWindow {
            window.windowLevel = UIWindow.Level.normal
        }
        dismiss(animated: false)
        let source = rootViewController
        let destination = defaultNavigationController(root: LoginViewController(), isNavigationBarHidden: false)
        
        if splash {
            return transitFromSplash(to: destination)
        } else {
            return transit(from: source, to: destination)
        }
    }
    
    private func addViewController(_ childController: UIViewController) {
        childController.willMove(toParent: self)
        addChild(childController)
        view.addFullsizeSubView(childController.view)
        childController.didMove(toParent: self)
    }
    
    private func removeViewController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.removeFromParent()
        childController.view.removeFromSuperview()
    }
    
    
    private func transitFromSplash(to destination: UIViewController) -> Promise<UIViewController> {
        if let splashViewController = self.splashViewController {
            return transit(from: splashViewController, to: destination)
        } else {
            return transit(from: SplashViewController(), to: destination)
        }
    }
    
    private func transit(from source: UIViewController,
                         to destination: UIViewController) -> Promise<UIViewController> {
        
        addViewController(destination)
        let (promise, resolver) = Promise<UIViewController>.pending()
        UIView.transition(
            with: self.view,
            duration: 0.5,
            options: [.transitionCrossDissolve],
            animations: {
                self.removeViewController(source)},
            completion: { _ in
                resolver.fulfill(destination) }
        )
        return promise
        
    }
    
}
