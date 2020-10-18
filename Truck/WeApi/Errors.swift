import Foundation

enum Errors: Error {
    case Empty
    case RefreshTokenFailed
    case requestError(message: String?, code: Int?)
    case TokenExpired
    case imageDataBroken
}
