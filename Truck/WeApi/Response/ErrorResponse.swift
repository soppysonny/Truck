import Foundation

public struct ErrorResponse: Codable {
    public let code: String
    public let userMessage: String
    public let details: [Detail]?

    public struct Detail: Codable {
        public let code: String
        public let target: String
        public let userMessage: String
    }

    public static func unAuthorized() -> ErrorResponse {
        return ErrorResponse(code: "error.auth.unauthorized", userMessage: "アクセストークンが無効です", details: nil)
    }

    public static func badParameter() -> ErrorResponse {
        return ErrorResponse(code: "403", userMessage: "parameter is nil", details: nil)
    }
}
