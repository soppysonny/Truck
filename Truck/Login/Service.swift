import PromiseKit
import Moya

class LoginService {
    let helper = APIHelper()
    func login(phoneNum: String, area: String, password: String) -> Promise<APIResponse<LoginResponse>> {
        let request = LoginRequest.init(phoneNum: phoneNum, area: area, password: password)
        let target = MultiTarget(API.login(reuqest: request))
        return helper.reuestWithoutAuth(target)
    }
}

struct LoginResponse: Codable {
    let token: String
    let user: LoginUser
    let role: LoginRole
    let company: LoginCompany
    let post: LoginPost
}

struct LoginUser: Codable {
    let userId: String
    let username: String
    let userCode: String
    let nickName: String
    let sex: String
    let companyId: String
    let postId: String
    let phoneNumber: String
    let email: String
    let userType: String
    let avatar: String
}

struct LoginRole: Codable {
    let roleId: String
    let roleName: String
    let roleKey: String
}

struct LoginCompany: Codable {
    let companyId: String
    let parentId: String
    let companyName: String
    let childType: String
    let childStatus: String
    let leader: String
    let businessLicense: String
    let licenseNum: String
    let logo: String
    let phone: String
    let telephone: String
    let vehicleNum: String
    let nickName: String
    let status: String
    let email: String
}

struct LoginPost: Codable {
    let postId: String
    let postCode: String
    let postName: String
    let status: String
}
