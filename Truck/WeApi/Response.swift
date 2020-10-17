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
    let msg: String
    let code: Int
    let fileName: String
    let url: String
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
    let phoneNumber: String?
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
    let postType: String?
    let status: String?
}


struct MyTaskRow: Codable {
    let id: String // 'String 调度id',
    let  projectId: String // 'String 工程id',
    let  vehicleNo: String // 'String 车号',
    let  driverNo: String // 'String 司机编号',
    let  upAddressId: String // 'String 装载点',
    let  peopleId: String // 'String 装点人员id',
    let  objectType: String // 'String 调度对象',
    let  dispatchStartTime: String // 'Date 任务开始时间',
    let  status: String // 'String 调度接受状态 0未接受 1已接受 ',
    let  companyId: String // 'String 公司id',
    let  projectName: String // 'String 工程名称',
    let  startDate: String // 'String 工程开始时间',
    let  endDate: String // 'String 工程结束时间',
    let  projectType: String // 'String 工程类型 1中标 2临时',
    let  projectStatus: String // 'String 工程状态 0启用 1停用',
    let  volume: String // 'String 预估立方',
    let  upAddressName: String // 'String 装载点名称'
}

