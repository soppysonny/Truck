import UIKit
public protocol TextConfigurable {
    func configure(font: UIFont,
                   textColor: UIColor,
                   alignment: NSTextAlignment)
}

public extension TextConfigurable where Self: UILabel {
    func configure(font: UIFont,
                   textColor: UIColor,
                   alignment: NSTextAlignment) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
}

public extension TextConfigurable where Self: UITextView {
    func configure(font: UIFont,
                   textColor: UIColor,
                   alignment: NSTextAlignment) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
}

public extension TextConfigurable where Self: UITextField {
    func configure(font: UIFont,
                   textColor: UIColor,
                   alignment: NSTextAlignment) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
}

extension UILabel: TextConfigurable {}
extension UITextView: TextConfigurable {}
extension UITextField: TextConfigurable {}
