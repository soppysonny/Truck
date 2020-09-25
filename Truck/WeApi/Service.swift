import PromiseKit
import Moya

class Service {
    let helper = APIHelper()
    
    func login(phone: String, area: String, password: String) -> Promise<APIResponse<SuccessResponse<LoginResponse>>> {
        let request = LoginRequest.init(phone: phone, area: area, password: password)
        let target = MultiTarget(API.login(reuqest: request))
        return helper.requestWithoutAuth(target)
    }
    
    func companyList() -> Promise<APIResponse<SuccessResponse<ListedCompanies>>> {
        let target = MultiTarget(API.listCompany)
        return helper.requestWithoutAuth(target)
    }
    
    func taskList(userId: String, status: String, roleKey: String) -> Promise<APIResponse<RowsSuccessResponse<MyTaskRow>>> {
        let request = TaskListRequest.init(roleKey: roleKey, status: status, userId: userId)
        let target = MultiTarget(API.listTask(request: request))
        return helper.requestWithoutAuth(target)
    }
}

