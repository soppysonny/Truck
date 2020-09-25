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
        }.catch{ error in
            RootViewController.shared.showLogin()
        }
    }
    
}
