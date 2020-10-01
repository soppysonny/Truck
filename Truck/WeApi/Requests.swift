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

struct ProjectListRequest: Encodable {
    let companyId: String
    let userId: String
}

struct VehiclesListRequest: Encodable {
    let companyId: String
    let userId: String
}

struct AddressListReuqst: Encodable {
    let companyId: String
    let userId: String
    let projectId: String?
    let addressType: String
}

struct ListOrderRequest: Encodable {
    let companyId: String
    let userId: String
}

struct AcceptTaskRequest: Encodable {
    let dispatchId: String
    let projectId: String?
    let vehicleId: String
    let status: String
    let userId: String
    let dispatchStartTime: Date //yyyy-MM-dd
    let companyId: String?
}

struct ConfirmRequest: Encodable {
    let type: Int
    let orderId: String
    let downId: String
    let imageList: [String]
}

struct JudgeLocationRequest: Encodable {
    let vehicleId: String
    let orderId: String
    let companyId: String
    let lng: String
    let lat: String
}

