import Foundation
import Toast_Swift
class HomeTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    let topPage = HomeViewController()
    let workBench = WorkBenchViewController()
    let vehMng = JSWebViewController(webType: .vehicleManage)
    let me = MeViewController()
    var nav3: UINavigationController?
    let iconNames = [
        "ic_tab_home",
        "ic_tab_message",
        "ic_tab_exception",
        "ic_tab_me"
    ]

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let user = LoginManager.shared.user,
              (user.post.postType != .driver) || viewController != nav3 else {
            UIApplication.shared.keyWindow?.makeToast("您没有权限进行车辆管理")
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let nav1 = defaultNavigationController(root: topPage)
        let nav2 = defaultNavigationController(root: workBench)
        nav3 = defaultNavigationController(root: vehMng)
        let nav4 = defaultNavigationController(root: me)
        
        nav1.tabBarItem.title = "首页"
        nav1.tabBarItem.image = UIImage(named: iconNames[0])
        nav1.tabBarItem.selectedImage = UIImage(named: iconNames[0] + "_selected")

        nav2.tabBarItem.title = "工作台"
        nav2.tabBarItem.image = UIImage(named: iconNames[1])
        nav2.tabBarItem.selectedImage = UIImage(named: iconNames[1] + "_selected")
        
        nav3?.tabBarItem.title = "车辆管理"
        nav3?.tabBarItem.image = UIImage(named: iconNames[2])
        nav3?.tabBarItem.selectedImage = UIImage(named: iconNames[2] + "_selected")
        
        
        nav4.tabBarItem.title = "我的"
        nav4.tabBarItem.image = UIImage(named: iconNames[3])
        nav4.tabBarItem.selectedImage = UIImage(named: iconNames[3] + "_selected")
        
        self.viewControllers = [
            nav1,
            nav2,
            nav3!,
            nav4
        ]
    }
    
}
