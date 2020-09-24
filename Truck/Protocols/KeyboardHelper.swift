
import UIKit

protocol KeyboardHelper: class {
    var willShowToken: NSObjectProtocol? { get set }
    var willHideToken: NSObjectProtocol? { get set }
    func handleUIKeyboardWillShowNotification(notification: Notification)
    func handleUIKeyboardWillHideNotification(notification: Notification)
    
}

extension KeyboardHelper where Self: BaseViewController {
    func startObservingEvents() {
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                               object: nil,
                                                               queue: nil) { [weak self] notification in
                                                                self?.handleUIKeyboardWillShowNotification(notification: notification)
        }
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                               object: nil,
                                                               queue: nil) { [weak self] notification in
                                                                self?.handleUIKeyboardWillHideNotification(notification: notification)
        }
        
    }
    
    func stopObervingEvents() {
        if let willShowToken = willShowToken {
            NotificationCenter.default.removeObserver(willShowToken)
        }
        if let willHideToken = willHideToken {
            NotificationCenter.default.removeObserver(willHideToken)
        }
    }
    
    func handleUIKeyboardWillShowNotification(notification: Notification) { /* implement when needed */ }
    func handleUIKeyboardWillHideNotification(notification: Notification) { /* implement when needed */ }
    
}
