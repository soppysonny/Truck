import Foundation

struct LoginRequest: Encodable {
    let phone: String
    let area: String
    let password: String
}


struct TaskListRequest: Encodable {
    let roleKey: String
    let status: String
    let userId: String
}
