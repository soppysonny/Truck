import Moya
enum API {
    case login(reuqest: LoginRequest)
    case listCompany
    case listTask(request: TaskListRequest)
    case listProject(request: ProjectListRequest)
    case listVehicles(request: VehiclesListRequest)
    case listAddress(request: AddressListReuqst)
    case acceptTask(request: AcceptTaskRequest)
    case refuseTask(request: RefuseTaskRequest)
    case confirmRequest(request: ConfirmRequest)
    case judgeLocation(request: JudgeLocationRequest)
    case uploadImage(data: Data)
    case processing(request: WorkbenchRequest)
    case finished(request: WorkbenchRequest)
    case abnormal(request: WorkbenchRequest)
    case orderDetail(request: OrderDetailRequest)
    case orderOperation(request: OrderOperationRequest)
}


extension API: TargetType {
    var method: Method {
        switch self {
        case .login(_):
            return .post
        default:
            return .post
        }
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
        case .listAddress(let request):
            return .requestJSONEncodable(request)
        case .confirmRequest(let request):
            return .requestJSONEncodable(request)
        case .judgeLocation(let request):
            return .requestJSONEncodable(request)
        case .uploadImage(let data):
            let multipart = MultipartFormData(provider: .data(data),
                                              name: "picture",
                                              fileName: "picture",
                                              mimeType: "image/jpeg")
            return .uploadMultipart([multipart])
        case .processing(let request):
            return .requestJSONEncodable(request)
        case .abnormal(let request):
            return .requestJSONEncodable(request)
        case .finished(let request):
            return .requestJSONEncodable(request)
        case .orderDetail(let request):
            return .requestJSONEncodable(request)
        case .orderOperation(let request):
            return .requestJSONEncodable(request)
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
        let url = URL.init(string: "http://118.178.225.142:8082")
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
            return "listPorjects"
        case .listVehicles(_):
            return "listVehicles"
        case .listAddress(_):
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
            return "dev-api//common/upload"
        case .abnormal:
            return "abnormal"
        case .processing:
            return "processing"
        case .finished:
            return "finished"
        case .orderDetail:
            return "getOrderDetails"
        case .orderOperation:
            return "orderOperation"
        }
    }
}
