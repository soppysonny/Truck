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

struct ArriveUpRequest: Encodable {
    let dispatchId: String
    let userId: String
}

struct JudgeLocationRequest: Encodable {
    let companyId: String
    let lat: Double
    let lng: Double
    let projectId: Double
    let userId: String
}

struct WorkbenchRequest: Encodable {
    let companyId: String
    let pageNum: Int
    let pageSize: Int = 10
    let userId: String
}

struct OrderDetailRequest: Encodable {
    let orderId: String
}

struct OrderOperationRequest: Encodable {
    let downId: String?
    let imageList: [String]?
    let orderId: String
    let type: Int
}
