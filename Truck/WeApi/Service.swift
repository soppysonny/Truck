import PromiseKit
import Moya

class Service {
    let helper = APIHelper()
    static let shared = Service()
    func login(phone: String, area: String, password: String) -> Promise<APIResponse<SuccessResponse<LoginResponse>>> {
        let request = LoginRequest.init(phone: phone, area: area, password: password)
        let target = MultiTarget(API.login(reuqest: request))
        return helper.requestWithoutAuth(target)
    }
    
    func companyList() -> Promise<APIResponse<SuccessResponse<ListedCompanies>>> {
        let target = MultiTarget(API.listCompany)
        return helper.requestWithoutAuth(target)
    }
    
    func taskList(userId: String, status: String, postType: String, pageNum: Int) -> Promise<APIResponse<SuccessResponse<[MyTaskRow]>>> {
        let request = TaskListRequest.init(postType: postType, status: status, userId: userId, pageNum: pageNum)
        let target = MultiTarget(API.listTask(request: request))
        return helper.requestWithoutAuth(target)
    }
    
    func uploadImage(image: UIImage) -> Promise<APIResponse<UploadFileResponse>> {
        guard let data = image.jpegData(compressionQuality: 0.75) else { fatalError() }
        let target = MultiTarget(API.uploadImage(data: data))
        return helper.requestWithoutAuth(target)
    }
    
    func acceptTask(dispatchId: String, dispatchStartTime: String, userId: String, vehicleId: String) -> Promise<APIResponse<SuccessResponse<String?>>> {
        return helper.request(MultiTarget.init(API.acceptTask(request: AcceptTaskRequest.init(dispatchId: dispatchId, dispatchStartTime: dispatchStartTime, userId: userId, vehicleId: vehicleId))))
    }
    
    func refuseTask(dispatchId: String, userId: String) -> Promise<APIResponse<SuccessResponse<String?>>> {
        return helper.request(MultiTarget.init(API.refuseTask(request: RefuseTaskRequest.init(dispatchId: dispatchId, userId: userId))))
    }
}

