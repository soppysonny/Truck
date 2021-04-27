import Foundation

class HomeTabbarViewController: UITabBarController {
    let topPage = HomeViewController()
    let workBench = WorkBenchViewController()
    let vehMng = UIViewController()
    let me = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [
            UINavigationController(rootViewController: topPage),
            UINavigationController(rootViewController: workBench),
            UINavigationController(rootViewController: vehMng),
            UINavigationController(rootViewController: me),
        ]
    }
    
}
