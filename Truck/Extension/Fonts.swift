import UIKit
enum FontFamily: String {
    case ArialMT
    case ArialMTBold = "Arial-BoldMT"
}
extension UIFont {    
    static func font(with size: CGFloat, fontName: String) -> UIFont{
        guard let font = UIFont.init(name: fontName, size: size) else {
            return .systemFont(ofSize: size);
        }
        return font
    }
}
