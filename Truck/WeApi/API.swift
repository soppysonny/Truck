import Moya
enum API {
    case login(reuqest: LoginRequest) // area 公司id
    case listCompany
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
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        baseHeader
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
        default:
            break;
        }
    }
}
