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
    static func provider(plugins: [PluginType] = []) -> MoyaProvider<MultiTarget> {
        return MoyaProvider<MultiTarget>(plugins: plugins)
    }
    
    static func postMaintenanceError() {
        NotificationCenter.default.post(name: .MaintenanceError,
                                        object: nil,
                                        userInfo: nil)
    }
    
    static func getError(_ response: Response) throws -> ErrorResponse? {
        if response.statusCode < 300 {
            return nil
        }
        return try ErrorResponse.decode(data: response.data)
    }

    private static func postVersionError(message: String) {
        NotificationCenter.default.post(name: .APIVersionError,
                                        object: nil,
                                        userInfo: ["message": message])
    }
    
    func reuestWithoutAuth<T: Codable>(_ target: MultiTarget, shouldPostErrorNotification: Bool = true) -> Promise<APIResponse<T>> {
        return Promise { resolver in
            APIHelper.provider().request(target) { result in
                switch result {
                case .success(let response):
                    // サーバーがメンテナンス時にハンドリングをする
                    if response.statusCode == maintenanceNumber && shouldPostErrorNotification {
                        APIHelper.postMaintenanceError()
                        return
                    }

                    do {
                        if let error = try APIHelper.getError(response) {
                            if error.code == versionErrorCode && shouldPostErrorNotification {
                                APIHelper.postVersionError(message: error.userMessage)
                                return
                            }
                            resolver.fulfill(APIResponse.failure(error))
                            return
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
}
