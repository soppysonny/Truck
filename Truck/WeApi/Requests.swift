import Foundation

struct LoginRequest: Encodable {
    let phone: String
    let area: String
    let password: String
}


