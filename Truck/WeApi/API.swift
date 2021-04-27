import Moya
import Alamofire
enum API {
    case login(reuqest: LoginRequest)
    case listCompany
    case listTask(request: TaskListRequest)
    case listProject(request: ProjectListRequest)
    case listVehicles(request: VehiclesListRequest)    
    case acceptTask(request: AcceptTaskRequest)
    case refuseTask(request: RefuseTaskRequest)
    case confirmRequest(request: ConfirmRequest)
    case judgeLocation(request: JudgeLocationRequest)
    case uploadImage(request: FileUploadRequest)
    case processing(request: WorkbenchRequest)
    case inTransit(request: WorkbenchRequest)
    case finished(request: WorkbenchRequest)
    case abnormal(request: WorkbenchRequest)
    case orderDetail(request: OrderDetailRequest)
    case orderOperation(request: OrderOperationRequest)
    case listAddress(request: ListAddressRequest)
    case changePassword(request: ChangePWRequest)
    case driverList(request: ListDriverRequest)
    case dispatch(request: DispatchRequest)
    case listNews(request: ListNewsRequests)
    case listNotices(request: ListNoticeRequest)
    case arriveUp(request: ArriveUpRequest)
    case newsDetail(request: NewsDetailRequest)
    case announceDetail(request: AnnounceDetailRequest)
    case listMsg(request: ListMsgRequest)
    case pollingList(request: PollingListRequest)
    case listTotalReport(request: ListTotalReportRequest)
    case listDetailReport(request: ListDetailReportRequest)
    case deleteOilOutById(request: RefuelingDeleteOilOutByIdRequest)
    case getOilOutByCreateBy(request: GetOilOutByCreateByRequest)
    case insertOilOut(request: InsertOilOutRequest)
    case listOilOutByDriverId(request: ListOilOutByDriverIdRequest)
    case updateOilOutById(request: UpdateOilOutByIdRequest)
    case updateOilOutStatus(request: UpdateOilOutStatusRequest)
    case deleteRepair(req: DeleteRepairRequest)
    case insertRepair(req: InsertRepairRequest)
    case listRepair(req: ListRepairRequest)
    case confirmViolation(req: ConfirmViolationRequest)
    case insertViolation(req: InserViolationRequest)
    case updateViolation(req: InserViolationRequest)
    case listViolationByDriver(req: ListViolationByDriverRequest)
    case listViolationByManager(req: ListViolationByManagerRequest)
    case listPeople(req: ListPeopleRequest)
    case listDictType(req: DictTypeRequest)
    case rejectOilOut(req: RejectOilOutRequest)
    case refuseViolation(req: ViolationRefuseRequest)
    case updateRepair(req: InsertRepairRequest)
}


extension API: TargetType {
    var method: Moya.Method {
        return Moya.Method.post
    }
    
    var sampleData: Data {
        fatalError()
    }
    
    var task: Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .listTask(let request):
            return .requestJSONEncodable(request)
        case .listProject(let request):
            return .requestJSONEncodable(request)
        case .listVehicles(let request):
            return .requestJSONEncodable(request)
        case .confirmRequest(let request):
            return .requestJSONEncodable(request)
        case .judgeLocation(let request):
            return .requestJSONEncodable(request)
        case .uploadImage(let request):
            let formatProvider = MultipartFormData.FormDataProvider.data(request.data)
            return .uploadMultipart([MultipartFormData.init(provider: formatProvider, name: request.name, fileName: request.fileName, mimeType: request.mimeType)])
        case .processing(let request):
            return .requestJSONEncodable(request)
        case .inTransit(let req):
            return .requestJSONEncodable(req)
        case .abnormal(let request):
            return .requestJSONEncodable(request)
        case .finished(let request):
            return .requestJSONEncodable(request)
        case .orderDetail(let request):
            return .requestJSONEncodable(request)
        case .orderOperation(let request):
            return .requestJSONEncodable(request)
        case .listAddress(let request):
            return .requestJSONEncodable(request)
        case .changePassword(let request):
            return .requestJSONEncodable(request)
        case .driverList(let request):
            return .requestJSONEncodable(request)
        case .dispatch(let request):
            return .requestJSONEncodable(request)
        case .listNews(let request):
            return .requestJSONEncodable(request)
        case .listNotices(let req):
            return .requestJSONEncodable(req)
        case .arriveUp(let req):
            return .requestJSONEncodable(req)
        case .announceDetail(let request):
            return .requestJSONEncodable(request)
        case .newsDetail(let request):
            return .requestJSONEncodable(request)
        case .listMsg(let request):
            return .requestJSONEncodable(request)
        case .pollingList(let request):
            return .requestJSONEncodable(request)
        case .acceptTask(let req):
            return .requestJSONEncodable(req)
        case .listTotalReport(let req):
            return .requestJSONEncodable(req)
        case .listDetailReport(let req):
            return .requestJSONEncodable(req)
        case .deleteOilOutById(let request):
            return .requestJSONEncodable(request)
        case .getOilOutByCreateBy(let req):
            return .requestJSONEncodable(req)
        case .insertOilOut(let req):
            return .requestJSONEncodable(req)
        case .listOilOutByDriverId(let req):
            return .requestJSONEncodable(req)
        case .updateOilOutById(let req):
            return .requestJSONEncodable(req)
        case .updateOilOutStatus(let req):
            return .requestJSONEncodable(req)
        case .deleteRepair(let req):
            return .requestJSONEncodable(req)
        case .insertRepair(let req):
            return .requestJSONEncodable(req)
        case .listRepair(let req):
            return .requestJSONEncodable(req)
        case .confirmViolation(let req):
            return .requestJSONEncodable(req)
        case .insertViolation(let req):
            return .requestJSONEncodable(req)
        case .listViolationByDriver(let req):
            return .requestJSONEncodable(req)
        case .listViolationByManager(let req):
            return .requestJSONEncodable(req)
        case .listPeople(let req):
            return .requestJSONEncodable(req)
        case .listDictType(let req):
            return .requestJSONEncodable(req)
        case .rejectOilOut(let req):
            return .requestJSONEncodable(req)
        case .updateViolation(let req):
            return .requestJSONEncodable(req)
        case .refuseTask(let req):
            return .requestJSONEncodable(req)
        case .refuseViolation(let req):
            return .requestJSONEncodable(req)
        case .updateRepair(let req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login, .listCompany:
            return baseHeader
        default:
            guard let token = LoginManager.shared.user?.token else {
                return baseHeader
            }
            print("token: ", token)
            return tokenHeader(token: token)
        }
        
    }
    
    var baseURL: URL {
        #if DEBUG
        let url = URL.init(string: "http://180.101.202.67:8082")
        #else
        let url = URL.init(string: "http://180.101.202.67:8082")
        #endif
        return url!
    }
    
    var path: String {
        switch self {
        case .login(_):
            return "login"
        case .listCompany:
            return "listCompany"
        case .listTask(_):
            return "listTask"
        case .listProject(_):
            return "listProject"
        case .listVehicles(_):
            return "listVehicles"
        case .listAddress:
            return "listAddress"
        case .confirmRequest(_):
            return "confirm"
        case .judgeLocation(_):
            return "judgeLocation"
        case .acceptTask(_):
            return "acceptTask"
        case .refuseTask:
            return "refuseTask"
        case .uploadImage:
            return "common/upload"
        case .abnormal:
            return "abnormal"
        case .processing:
            return "processing"
        case .inTransit:
            return "inTransit"
        case .finished:
            return "finished"
        case .orderDetail:
            return "getOrderDetails"
        case .orderOperation:
            return "orderOperation"
        case .changePassword:
            return "/system/user/profile/updatePwd"
        case .driverList:
            return "listDrivers"
        case .dispatch:
            return "dispatch"
        case .listNews:
            return "/notice/listNews"
        case .listNotices:
            return "/notice/listNotice"
        case .arriveUp:
            return "arriveUp"
        case .newsDetail:
            return "/notice/newsDetail"
        case .announceDetail:
            return "/notice/noticeDetail"
        case .listMsg:
            return "listMsg"
        case .pollingList:
            return "pollingList"
        case .listDetailReport:
            return "listDetailReport"
        case .listTotalReport:
            return "listTotalReport"
        case .deleteOilOutById:
            return "/refueling/deleteOilOutById"
        case .getOilOutByCreateBy:
            return "/refueling/getOilOutByCreateBy"
        case .insertOilOut:
            return "/refueling/insertOilOut"
        case .listOilOutByDriverId:
            return "/refueling/listOilOutByDriverId"
        case .updateOilOutById:
            return "/refueling/updateOilOutById"
        case .updateOilOutStatus:
            return "/refueling/updateOilOutStatus"
        case .deleteRepair:
            return "deleteRepair"
        case .insertRepair:
            return "insertRepair"
        case .listRepair:
            return "listRepair"
        case .confirmViolation:
            return "confirmPeccancy"
        case .insertViolation:
            return "insertPeccancy"
        case .listViolationByDriver:
            return "listPeccancyByDriver"
        case .listViolationByManager:
            return "listPeccancyByManager"
        case .listPeople:
            return "listPeople"
        case .listDictType:
            return "/system/dict/data/dictType"
        case .rejectOilOut:
            return "/refueling/oilOutStatusRefuse"
        case .updateViolation:
            return "/updatePeccancy"
        case .refuseViolation:
            return "/vehiclePeccancyStatusRefuse"
        case .updateRepair:
            return "/updateRepair"
        }
    }
}
