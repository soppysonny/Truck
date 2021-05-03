import Foundation

public enum KeychainManagerType: String {
    case deviceuuid = "deviceuuid"
}

public class KeychainManager {
    
    public static func writeValue(key: String, value: String) {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.alwaysThisDeviceOnly)
        keychain[key] = value
    }
    
    public static func readValue(key: String) -> String? {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.alwaysThisDeviceOnly)
        return keychain[key]
    }
    
    #if DEBUG
    public static func deleteValue(key: String) {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!).accessibility(.alwaysThisDeviceOnly)
        keychain[key] = nil
    }
    #endif
}

extension KeychainManager {
    
    public static func getValue(type: KeychainManagerType) -> String {
        guard let value = readValue(key: type.rawValue) else {
            return setValue(type: type)
        }
        return value
    }
    
    public static func setValue(type: KeychainManagerType) -> String {
        var id = ""
        switch type {
        case .deviceuuid:
            id = UIDevice.current.identifierForVendor!.uuidString
        }
        writeValue(key: type.rawValue, value: id)
        return id
    }
}
