import Foundation

extension Notification.Name {
    public static let APIAccountError = Notification.Name("APIAccountError")
    public static let APIVersionError = Notification.Name("APIVersionError")
    public static let MaintenanceError = Notification.Name("MaintenanceError")

    public static let DidUpdateProfile = Notification.Name("DidUpdateProfile")

    public static let DismissGeneralModal = Notification.Name("DismissGeneralModal")
    
    public static let ShowHome = Notification.Name("ShowHome")
    public static let ShowLogin = Notification.Name("ShowLogin")
}
