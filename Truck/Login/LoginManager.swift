import UIKit

class LoginManager {
    static let shared = LoginManager()
    var isLoggedIn = false
    var user: LoginResponse?
    
    
    init() {

    }

    func setup() {
        LoginResponse.getLoginInfoFromDefaults().done { [weak self] result in
            guard let self = self else { return }
            self.user = result
            self.isLoggedIn = true
            RootViewController.shared.showHome()
            LocationManager.shared.setup()
            LocationManager.shared.startUpdatingLocation()
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
