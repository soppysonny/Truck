import UIKit

//https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html
class ActionTrampoline<T>: NSObject {
    var action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    // swiftlint:disable force_cast
    @objc func action(sender: UIControl) {
        action(sender as! T)
    }
    
}

private let TPKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)
public protocol UIControlActionFunctionProtocol { }

extension UIControl {

    fileprivate var trampolines: [UInt: AnyObject] {
        get {
            return objc_getAssociatedObject(self, TPKey) as? [UInt: AnyObject]
                    ?? [:]
        }
        set(val) {
            objc_setAssociatedObject(self, TPKey, val, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}

extension UIControlActionFunctionProtocol where Self: UIControl {

    /// closureでイベント追加。一つのUIControlEventsにつきイベント一個まで。
    public func addAction(events: UIControl.Event, _ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        addTarget(trampoline,
                action: #selector(ActionTrampoline<UIControl>.action(sender:)),
                for: events)
        trampolines[events.rawValue] = trampoline
    }
}

extension UIControl: UIControlActionFunctionProtocol {}
