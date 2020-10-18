import Foundation

struct LoginRequest: Encodable {
    let phone: String
    let area: String
    let password: String
}


struct TaskListRequest: Encodable {
    let postType: String
    let status: String
    let userId: String
    let pageNum: Int
    let pageSize: Int = 10
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

struct AcceptTaskRequest: Encodable {
    let dispatchId: String
    let dispatchStartTime: String //yyyy-MM-dd
    let userId: String
    let vehicleId: String
}

struct RefuseTaskRequest: Encodable {
    let dispatchId: String
    let userId: String
}
