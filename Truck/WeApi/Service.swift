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

    
    
    func workbenchList(type: WorkbenchListType, companyId: String, pageNum: Int, userId: String) -> Promise<APIResponse<SuccessResponse<WorkbenchList>>> {
        switch type {
        case .abnormal:
            return helper.request(MultiTarget.init(API.abnormal(request: WorkbenchRequest.init(companyId: companyId, pageNum: pageNum, userId: userId))))
        case .finished:
            return helper.request(MultiTarget.init(API.finished(request: WorkbenchRequest.init(companyId: companyId, pageNum: pageNum, userId: userId))))
        case .processing:
            return helper.request(MultiTarget.init(API.processing(request: WorkbenchRequest.init(companyId: companyId, pageNum: pageNum, userId: userId))))
        }
    }

    func orderDetail(orderId: String) -> Promise<APIResponse<SuccessResponse<OrderDetailResponse>>> {
        return helper.request(MultiTarget.init(API.orderDetail(request: OrderDetailRequest.init(orderId: orderId))))
    }

//    1装车确认 2卸车确认 3转运申请 4现场管理员现场确认 5转运确认 6正常完成确认 7异常申请 8异常上传图片
    func orderOperation(downId: String?, imageList: [String]?, orderId: String, type: Int) -> Promise<APIResponse<SuccessResponse<OrderOperationResponse>>> {
        return helper.request(MultiTarget.init(API.orderOperation(request: OrderOperationRequest.init(downId: downId, imageList: imageList, orderId: orderId, type: type))))
    }
    
}

