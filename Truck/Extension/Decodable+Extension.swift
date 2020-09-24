import Foundation

extension Decodable {
    public static func decode(data: Data, format: DateFormat? = nil) throws -> Self {
        let decoder = JSONDecoder()
        if data.isEmpty {
            return try decoder.decode(self, from: "{}".data(using: .utf8) ?? Data())
        }
        if let format = format {
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
        }
        return try decoder.decode(self, from: data)
    }
}
