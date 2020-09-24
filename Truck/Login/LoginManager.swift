import UIKit

class LoginManager {
    static let shared = LoginManager()
    var isLoggedIn = false
    var token: String? {
        didSet {
            guard token != nil else {
                isLoggedIn = false
                return
            }
            isLoggedIn = true
        }
    }
    
    init() {
        token = UserDefaults.standard.string(forKey: "login_token")
    }
    
    
    
}
