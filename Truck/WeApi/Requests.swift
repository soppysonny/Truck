import Foundation

struct LoginRequest: Encodable {
    let phone: String
    let area: String
    let password: String
}


struct TaskListRequest: Encodable {
    let postType: String
    let status: Int
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
    let vehicleId: String?
}

struct RefuseTaskRequest: Encodable {
    let dispatchId: String
    let userId: String
    let reason: String
}

struct ArriveUpRequest: Encodable {
    let dispatchId: String
    let userId: String
    let lng: Double
    let lat: Double
}

struct WorkbenchRequest: Encodable {
    let companyId: String
    let pageNum: Int
    let pageSize: Int = 10
    let userId: String
    let plateNum: String?
}

struct OrderDetailRequest: Encodable {
    let orderId: String
}

struct OrderOperationRequest: Encodable {
    let downId: String?
    let imageList: [ImageListElement]?
    let orderId: String
    let type: Int
    let lng: Double
    let lat: Double
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

struct ListNoticeRequest: Encodable {
    let companyId: String
    let pageNum: Int
    let pageSize: Int? = 10
}

struct JudgeLocationRequest: Encodable {
    let companyId: String
    let lat: Double
    let lng: Double
    let projectId: String?
    let userId: String
}

struct NewsDetailRequest: Encodable {
    let id: String
}

struct AnnounceDetailRequest: Encodable {
    let id: String
}

struct PollingListRequest: Encodable {
    let companyId: String
    let createTime: String
    let postType: PostType
    let userId: String
}

struct ListMsgRequest: Encodable {
    let companyId: String
    let pageNum: Int
    let pageSize: Int? = 10
    let postType: String
    let userId: String
}

struct ListTotalReportRequest: Encodable {
    let companyId: String
    let endDate: String?
    let startDate: String?
    let userId: String
    /*
     endDate": "2020-10-23 11:44:23",
     startDate": "2020-10-16 11:44:23"
     */
}

struct ListDetailReportRequest: Encodable {
    let companyId: String
    let endDate: String?
    let startDate: String?
    let userId: String
    
    /*
     endDate": "2020-10-23 11:45:06",
     startDate": "2020-10-16 11:45:06"
     */
}

struct RefuelingDeleteOilOutByIdRequest: Encodable {
    let id: String
}

struct GetOilOutByCreateByRequest: Encodable {
    let beginTime: String
    let companyId: String
    let endTime: String
    let pageNum: Int
    let pageSize: Int? = 10
    let type: Int
    let userId: String
}

struct InsertOilOutRequest: Encodable {
    let companyId: String
    let createBy: String
    let driverId: String
    let imageList: [ImageListElement]
    let oilPrice: Double
    let oilTonnage: Double
    let oilType: String
    let total: Double
    let vehicleId: String
}

struct ListOilOutByDriverIdRequest: Encodable {
    let beginTime: String
    let endTime: String
    let pageNum: Int
    let pageSize: Int? = 10
    let type: Int
    let userId: String
}

struct UpdateOilOutByIdRequest: Encodable {
    let driverId: String
    let id: String
    let imageList: [ImageListElement]
    let oilPrice: Double
    let oilTonnage: Double
    let oilType: String
    let total: Double
    let updateBy: String
    let vehicleId: String
}

struct UpdateOilOutStatusRequest: Encodable {
    let oilOutId: String
}

struct RejectOilOutRequest: Encodable {
    let oilOutId: String
    let rejectReason: String
}

struct DeleteRepairRequest: Encodable {
    let id: String
}

struct InsertRepairRequest: Encodable {
    let endTime: String
    let imageList: [ImageListElement]
    let price: Double
    let repairFlag: Int
    let repairType: String
    let startTime: String
    let userId: String
    let vehicleId: String
    let id: String?
}

struct ListRepairRequest: Encodable {
    let endTime: String
    let pageNum: Int
    let pageSize: Int? = 10
    let startTime: String
    let type: Int
    let userId: String
}

struct ConfirmViolationRequest: Encodable {
    let peccancyId: String
}

struct InserViolationRequest: Encodable {
    let imageList: [ImageListElement]
    let peccancyTime: String
    let peccancyType: String
    let peopleId: String
    let price: Double
    let userId: String
    let vehicleId: String
    let peccancyId: String?
}

struct ListViolationByDriverRequest: Encodable {
    let endTime: String
    let startTime: String?
    let pageNum: Int
    let pageSize: Int?
    let userId: String?
    let type: Int
}

struct ListViolationByManagerRequest: Encodable {
    let endTime: String
    let startTime: String
    let pageNum: Int?
    let pageSize: Int?
    let peopleId: String
    let type: Int
}

struct ListPeopleRequest: Encodable {
    let companyId: String
}

struct DictTypeRequest: Encodable {
    let dictType: DictType
}

enum DictType: String, Codable {
    case soil_type = "soil_type"
    case oil_type = "oil_type"
    case repair_type = "repair_type"
    case peccancy_type = "peccancy_type"
    case repair_flag = "repair_flag"
}

struct ViolationRefuseRequest: Encodable {
    let rejectReason: String
    let peccancyId: String
}
