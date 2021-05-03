import Foundation
import CleanJSON
extension Decodable {
    public static func decode(data: Data, format: DateFormat? = nil) throws -> Self {
        let decoder = CleanJSONDecoder()
        if data.isEmpty {
            return try decoder.decode(self, from: "{}".data(using: .utf8) ?? Data())
        }
        if let format = format {
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
        }
        let string = String.init(data: data, encoding: .utf8)
        if var dict = string?.toDictionary() {
            if let number = dict["msg"] as? Int {
                dict["msg"] = String.init(format: "%d", number)
                if let modifiedData = dict.toString()?.data(using: .utf8) {
                    return try decoder.decode(self, from: modifiedData)
                }
            }
        }
        return try decoder.decode(self, from: data)
    }
}
