import Moya
enum API {
    case login(reuqest: LoginRequest) // area 公司id
    case listCompany
    case listTask(request: TaskListRequest)
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
        default:
            break;
        }
    }
}
