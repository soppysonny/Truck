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
    let userId: String?
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
    let imageList: [ImageListElement]?
    let orderId: String
    let type: Int
}

struct ImageListElement: Codable {
    let name: String?
    let url: String?
}

struct ListAddressRequest: Encodable {
    let addressType: String //装卸点类型，1装点，2卸点
    let companyId: String
    let projectId: String
    let userId: String?
}

struct FileUploadRequest: Encodable {
    let data: Data
    let fileName: String
    let name: String
    let mimeType: String
}

struct ChangePWRequest: Encodable {
    let newPassword: String
    let oldPassword: String
}

struct ListDriverRequest: Encodable {
    let vehicleId: String
}

struct DispatchRequest: Encodable {
    let companyId: String
    let projectId: String
    let upAddressId: String
    let userId: String
    let vehicleId: String
}

struct ListNewsRequests: Encodable {
    let companyId: String
}
