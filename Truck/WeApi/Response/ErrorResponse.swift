import Foundation

public struct ErrorResponse: Codable {
    public let code: Int
    public let msg: String
}
