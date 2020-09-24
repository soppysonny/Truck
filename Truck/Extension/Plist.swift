import Foundation

public class Plist {

    private let bundle: Bundle

    public init(bundle: Bundle) {
        self.bundle = bundle
    }

    public func list<T>(_ plistFile: String) -> [T] where T: Decodable {
        let data = generateData(with: plistFile)
        guard let array: [T] = try? PropertyListDecoder().decode([T].self, from: data) else {
            fatalError("Cannot create array from data")
        }

        return array
    }

    public func dictionary(_ plistFile: String) -> [String: String] {
        let data = generateData(with: plistFile)
        guard let dictionary: [String: String] =
            try? PropertyListDecoder().decode([String: String].self, from: data) else {
                fatalError("Cannot create array from data")
        }

        return dictionary

    }

    private func generateData(with plistFile: String) -> Data {
        guard let path = bundle.path(forResource: plistFile, ofType: "plist") else {
            fatalError("plist not found")
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Cannot create data from plist data.")
        }

        return data
    }
}
