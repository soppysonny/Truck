import Foundation
import PromiseKit
import Moya
import Alamofire

private let versionErrorCode = "error.oldVersionApplication"
private let unauthorizedNumber = 401
let maintenanceNumber = 503

public enum APIResponse<T> {
    public typealias ResponseType = T
    case success(ResponseType)
    case failure(ErrorResponse)
}

class APIHelper {
    typealias ResponseResult = ResultResult<Response, MoyaError>.TypeClass
    static func provider(plugins: [PluginType] = []) -> MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(plugins: plugins)
    }
    
    static func postMaintenanceError() {
        NotificationCenter.default.post(name: .MaintenanceError,
                                        object: nil,
                                        userInfo: nil)
    }
    
    static func getError(_ response: Response) throws -> ErrorResponse? {
        return try ErrorResponse.decode(data: response.data)
    }

    private static func postVersionError(message: String) {
        NotificationCenter.default.post(name: .APIVersionError,
                                        object: nil,
                                        userInfo: ["message": message])
    }
    
    func request<T: Codable>(_ target: MultiTarget) -> Promise<APIResponse<T>> {
        return Promise { resolver in
            APIHelper.provider().request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        if let error = try APIHelper.getError(response) {
                            if error.code != 200 {
                                if error.code == 401 {
                                    LoginManager.shared.logout()
                                }
                                resolver.fulfill(APIResponse.failure(error))
                                return
                            }
                        }
                        let data = try T.decode(data: response.data)
                        resolver.fulfill(APIResponse.success(data))
                    } catch {
                        resolver.reject(error)
                    }
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    func requestWithoutAuth<T: Codable>(_ target: MultiTarget) -> Promise<APIResponse<T>> {
        return Promise { resolver in
            APIHelper.provider().request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        if let error = try APIHelper.getError(response) {
                            if error.code != 200 {
                                resolver.fulfill(APIResponse.failure(error))
                                return
                            }
                        }
                        let data = try T.decode(data: response.data)
                        resolver.fulfill(APIResponse.success(data))
                    } catch {
                        resolver.reject(error)
                    }
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }

    func callApiPromise<T: Codable>(apiTask: @escaping (AccessTokenPlugin) -> Promise<APIHelper.ResponseResult>) -> Promise<APIResponse<T>> {
       let (promise, resolver) = Promise<APIResponse<T>>.pending()
        firstly {
            authWithCall(apiTask)
        }.done { result in
            switch result {
            case .success(let response):
                do {
                    let data = try T.decode(data: response.data)
                    resolver.fulfill(APIResponse.success(data))
                } catch {
                    resolver.reject(error)
                }
            case .failure(let error):
                resolver.reject(error)
            }
        }.catch{ error in
            resolver.reject(error)
        }
        return promise
    }
    
    private func authWithCall(_ apiTask: @escaping (AccessTokenPlugin) -> Promise<ResponseResult>)
        -> Promise<ResponseResult> {
            return Promise { resolver in
                let token = LoginManager.shared.user?.token ?? ""
                let plugin = AccessTokenPlugin(tokenClosure: { _ in token })
                let apiTaskWithPlugin = apiTask(plugin)
                firstly {
                    apiTaskWithPlugin
                }.done { result in
                    resolver.fulfill(result)
                }.catch { error in
                    resolver.reject(error)
                }
            }
    }

}
