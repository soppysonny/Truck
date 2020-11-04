import Foundation
import PromiseKit
public struct ErrorResponse: Codable {
    public let code: Int
    public let msg: String?
}

struct SuccessResponse<T: Codable>: Codable {
    let msg: String?
    let code: Int
    let data: T?
    let total: Int?
}

struct UploadFileResponse: Codable{
    let msg: String?
    let code: Int?
    let fileName: String?
    let url: String?
}

struct EmptyResponse: Codable {
    
}

typealias ListedCompanies = [ListedCompany]

struct ListedCompany: Codable {
    let companyId: String
    let companyName: String?
    let childType: String?
    let childStatus: String?
    let leader: String?
    let businessLicense: String?
    let licenseNum: String?
    let logo: String?
    let phone: String?
    let telephone: String?
    let vahicleNum: String?
    let nickName: String?
    let status: String?
    let email: String?
    let alias: String?
}

struct LoginResponse: Codable {
    let user: LoginUser
    let company: LoginCompany
    let post: LoginPost
    let vehicle: [LoginVehicleListElement]?
    let token: String
    let menuList: [LoginMenuListElement]?
    let role: LoginRole?
    func saveToDefaults() -> Promise<String> {
        let (promise, resolver) = Promise<String>.pending()
        do {
            let encoded = try JSONEncoder().encode(self)
            if let string = String.init(data: encoded, encoding: .utf8)  {
                UserDefaults.standard.setValue(string, forKey: "LoginUser")                
                resolver.fulfill(string)
            } else {
                resolver.reject(Errors.Empty)
            }
        } catch {
            resolver.reject(error)
        }
        return promise
    }
    
    static func getLoginInfoFromDefaults() -> Promise<LoginResponse> {
        let (promise, resolver) = Promise<LoginResponse>.pending()
        guard let string = UserDefaults.standard.string(forKey: "LoginUser"),
            let data = string.data(using: .utf8) else {
            resolver.reject(Errors.Empty)
            return promise
        }
        do {
            let loginUser = try JSONDecoder().decode(LoginResponse.self, from: data)
            resolver.fulfill(loginUser)
        } catch {
            resolver.reject(error)
        }
        return promise
    }
}

struct LoginUser: Codable {
    let userId: String
    let userName: String?
    let userCode: String?
    let nickName: String?
    let sex: String?
    let companyId: String?
    let postId: String?
    let phonenumber: String?
    let email: String?
    let userType: String?
    let avatar: String?
}

struct LoginRole: Codable {
    let roleId: String
    let roleName: String?
    let roleKey: String?
}

struct LoginCompany: Codable {
    let alias: String?
    let businessLicense: String?
    let childStatus: String?
    let childType: String?
    let companyId: String
    let companyName: String?
    let email: String?
    let leader: String?
    let licenseNum: String?
    let logo: String?
    let nickName: String?
    let phone: String?
    let status: String?
    let telephone: String?
    let validKey: String?
    let validStart: String?
    let vehicleNum: String?
}

struct LoginMenuListElement: Codable {
    let menuId: String
    let menuName: String?
    let orderNum: Int?
    let parentId: String?
}

struct LoginVehicleListElement: Codable {
    let companyId: String
    let createTime: String?
    let driveNum: String?
    let frameNum: String?
    let id: String
    let plateNum: String?
    let tonnage: String?
    let vehicleBrand: String?
    let vehicleName: String?
    let vehicleType: String?
}

struct LoginPost: Codable {
    let postCode: String?
    let postId: String
    let postName: String?
    let postType: PostType? 
    let status: String? // 状态 0正常 1停用'
    
}

enum PostType: String, Codable {
    case driver = "driver" // 油罐车司机
    case siteManager = "siteManager" // 装点管理员
    case manager = "manager" // 调度员
    case truckDriver = "truckDriver" // 司机
    case excavateDriver = "excavateDriver" //挖机
}

struct MyTaskRow: Codable {
    let id: String // 'String 调度id',
    let projectId: String? // 'String 工程id',
    let vehicleId: String? // 'String 车号',
    let vehicleName: String?
    let vehiclePlateNum: String?
    let driverId: String?
    let driverNickName: String?
    let upAddressId: String? // 'String 装载点',
    let peopleId: String? // 'String 装点人员id',
    let objectType: String? // 'String 调度对象',
    let dispatchStartTime: String? // 'Date 任务开始时间',
    let dispatchEndTime: String?
    let status: String? // 'String 调度接受状态 0未接受 1已接受 ',
    let companyId: String? // 'String 公司id',
    let projectName: String? // 'String 工程名称',
    let startDate: String? // 'String 工程开始时间',
    let endDate: String? // 'String 工程结束时间',
    let phonenumber: String?
    let projectType: String? // 'String 工程类型 1中标 2临时',
    let projectStatus: String? // 'String 工程状态 0启用 1停用',
    let peopleNickName: String?
    let volume: String? // 'String 预估立方',
    let upAddressName: String? // 'String 装载点名称'
    let upWord: String?
    let isFinish: String?
    let amount: String?
    let createTime: String?
}

typealias WorkbenchList = [WorkbenchListElement]

struct WorkbenchListElement: Codable {
    let companyId: String?
    let createTime: String?
    let dispatchId: String?
    let downId: String?
    let downName: String?
    let downPhone: String?
    let downWord: String?
    let driverId: String?
    let driverName: String?
    let id: String?
    let isNormal: String?
    let isTransport: String?
    let linkman: String?
    let peopleId: String?
    let projectId: String?
    let projectName: String?
    let status: String?
    let transportAddress: String?
    let transportAddressName: String?
    let transportWord: String?
    let upId: String?
    let upManagerNickName: String?
    let upName: String?
    let upPhone: String?
    let upWord: String?
    let vehicleId: String?
    let vehiclePlateNum: String
}

struct OrderDetailResponse: Codable {
    let arriveDownTime: String?
    let arriveUpTime: String?
    let checkTime: String?
    let companyId: String?
    let count: String?
    let createTime: String?
    let delFlag: String?
    let dispatchId: String?
    let downId: String?
    let downName: String?
    let downPhone: String?
    let downWord: String?
    let driverId: String?
    let driverName: String?
    let finishTime: String?
    let id: String?
    let isNormal: String?
    let isTransport: String?
    let linkman: String?
    let peopleId: String?
    let projectId: String?
    let projectName: String?
    let remark: String?
    let status: String?
    let transportAddress: String?
    let transportAddressName: String?
    let transportConfirm: String?
    let transportTime: String?
    let transportWord: String?
    let upId: String?
    let upManagerNickName: String?
    let upName: String?
    let upPhone: String?
    let upTime: String?
    let upWord: String?
    let vehicleFlag: String?
    let vehicleId: String?
    let vehiclePlateNum: String?
}

struct OrderOperationResponse: Codable {
    let downId: String?
    let imageList: [String]?
    let orderId: String
    let type: Int
}

struct ListAddressResponse: Codable {
    let addressName: String? //类型 1 装点 2 卸点
    let addressType: String?
    let addressWord: String?
    let companyId: String?
    let id: String?
    let manager: String?
    let phone: String?
    let status: String?
}

struct ProjectListElement: Codable {
    let companyId: String?
    let createTime: String?
    let endDate: String?
    let projectId: String?
    let projectName: String?
    let projectType: String?
    let startDate: String?
    let type: String?
    let volume: String?
}

struct DriverListElement: Codable {
    let companyId: String?
    let createTime: String?
    let nickName: String?
    let postType: String?
    let userId: String?
}

struct ListNewsResponse: Codable {
    let content: String?
    let createTime: String?
    let id: String?
    let imageList: [ImageListElement]?
    let title: String?
}

struct ListNoticeResponse: Codable {
    let searchValue: String?
    let createBy: String?
    let createTime: String? //"2020-10-14 11:52:47",
    let updateBy: String?
    let updateTime: String?
    let remark: String?
    let dataScope: String?
    let params: [String: String]?
    let companyId: String?
    let id: String?
    let title: String?
    let content: String?
}

struct AnnounceDetailResponse: Codable {
    let companyId: String?
    let content: String?
    let createBy: String?
    let createTime: String?
    let dataScope: String?
    let id: String?
    let params: [String: String]?
    let remark: String?
    let searchValue: String?
    let title: String?
    let updateBy: String?
    let updateTime: String?
}

struct NewsDetailResponse: Codable {
    let content: String?
    let createTime: String?
    let id: String?
    let imageList: [ImageListElement]?
    let title: String?
}

struct JudgeLocationElement: Codable {
    let resultType: JudgeLocationResultType
}

struct ListMsgResponseElement: Codable {
    let companyId: String?
    let createBy: String?
    let createName: String?
    let createTime: String?
    let id: String?
    let msgId: String?
    let msgTitle: String?
    let msgType: MsgType?
}

typealias ListMsgResponse = [ListMsgResponseElement]

struct PollingResultElement: Codable {
    let hasNewMsg: String
}

typealias PollingListResponse = [PollingResultElement]

enum MsgType: String, Codable {
    case announce = "1"
    case dispatch = "2"
    case load = "3"
    case setUnload = "4"
    case applyTransfer  = "5"
    case setNewUnload  = "6"
    case newTask = "7"
    case nine = "9"
}

struct ListTotalReportElement: Codable {
    let income: String?
    let oilTotal: String?
    let peccancyPrice: String?
    let repairPrice: String?
}

typealias ListTotalReportReponse = [ListTotalReportElement]

struct ListDetailReportElement: Codable {
    let addressName: String?
    let downName: String?
    let mileage: String?
    let plateNum: String?
    let price: String?
    let rounds: String?
    let totalPrice: String?
    let vehicleId: String?
}

typealias ListDetailReportResponse = [ListDetailReportElement]

struct GetOilOutByCreateByElement: Codable {
    let companyId: String?
    let createBy: String?
    let createTime: String?
    let driverId: String?
    let driverName: String?
    let id: String?
    let imageList: [ImageListElement]?
    let oilPrice: Double?
    let oilTonnage: Double?
    let oilType: String?
    let plateNum: String?
    let status: String?
    let total: Double?
    let updateBy: String?
    let updateTime: String?
    let vehicleId: String?
}

typealias GetOilOutByCreateByResponse = [GetOilOutByCreateByElement]

typealias GetOilOutByDriverIdResponse = [GetOilOutByCreateByElement]

struct ListRepairElement: Codable {
    let companyId: String?
    let companyName: String?
    let createBy: String?
    let createTime: String?
    let creatorName: String?
    let endTime: String?
    let id: String?
    let images: [String]?
    let isPayment: String?
    let plateNum: String?
    let rejectReason: String?
    let repairPrice: Double?
    let repairType: String?
    let startTime: String?
    let status: String?
    let updateBy: String?
    let updateTime: String?
    let updaterName: String?
    let vehicleId: String?
    let vehicleName: String?
}

typealias ListRepairResponse = [ListRepairElement]

struct ListViolationElement: Codable {
    let companyId: String?
    let companyName: String?
    let createBy: String?
    let createTime: String?
    let creatorName: String?
    let id: String?
    let images: [ImageListElement]?
    let isPayment: String?
    let peccancyPrice: Double?
    let peccancyTime: String?
    let peccancyType: String?
    let peopleId: String?
    let peopleName: String?
    let plateNum: String?
    let rejectReason: String?
    let status: String?
    let updateBy: String?
    let updateTime: String?
    let updaterName: String?
    let userId: String?
    let userName: String?
    let vehicleId: String?
    let vehicleName: String?
}

typealias ListViolationByDriverResponse = [ListViolationElement]
typealias ListViolationByManagerResponse = [ListViolationElement]

struct ListPeopleElement: Codable {
    let createTime: String?
    let peopleId: String?
    let peopleNickName: String?
}

typealias ListPeopleResponse = [ListPeopleElement]

struct DictElement: Codable {
    let dictLabel: String?
    let dictValue: String?
}

typealias DictResponse = [DictElement]
