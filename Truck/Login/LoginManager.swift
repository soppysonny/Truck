import UIKit

class LoginManager {
    static let shared = LoginManager()
    var isLoggedIn = false
    var user: LoginResponse?
    
    
    init() {

    }

    func setup() {
        LocationManager.shared.setup()
        LocationManager.shared.startUpdatingLocation()
        LoginResponse.getLoginInfoFromDefaults().done { [weak self] result in
            guard let self = self else { return }
            self.user = result
            self.isLoggedIn = true
            if let value = UserDefaults.standard.value(forKey: "pw") as? String,
               value == "000000" {
                RootViewController.shared.showForceReivisePW()
            } else {
                RootViewController.shared.showHome()
            }
            LocationManager.shared.startPolling()
        }.catch{ error in
            RootViewController.shared.showLogin()
        }
    }
    
    func logout() {
        UserDefaults.standard.setValue(nil, forKey: "LoginUser")
        user = nil        
        setup()
    }
    
}
