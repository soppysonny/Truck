import Foundation
import PromiseKit
public struct ErrorResponse: Codable {
    public let code: Int
    public let msg: String
}

struct SuccessResponse<T: Codable>: Codable {
    let msg: String
    let code: Int
    let data: T
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
    let token: String
    let user: LoginUser
    let role: LoginRole
    let company: LoginCompany
    let post: LoginPost
    
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
    let companyId: String
    let parentId: String?
    let companyName: String?
    let childType: String?
    let childStatus: String?
    let leader: String?
    let businessLicense: String?
    let licenseNum: String?
    let logo: String?
    let phone: String?
    let telephone: String?
    let vehicleNum: String?
    let nickName: String?
    let status: String?
    let email: String?
}

struct LoginPost: Codable {
    let postId: String
    let postCode: String?
    let postName: String?
    let status: String?
}


