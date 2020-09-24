import UIKit

extension UIView {

    public convenience init(size: CGSize) {
        self.init(frame: .init(origin: .zero, size: size))
    }

    public enum SubviewResizing {
        case autoResizeMask
        case autoLayout
        case autoLayoutWithPriority(UILayoutPriority)
    }

    public func addFullsizeSubView(_ view: UIView, resizing: SubviewResizing = .autoLayout) {
        switch resizing {
        case .autoResizeMask:
            addFullsizeSubViewWithAutoResizeMask(view)
        case .autoLayout:
            addFullsizeSubViewWithAutoLayout(view)
        case .autoLayoutWithPriority:
            addFullsizeSubViewWithAutoLayout(view)
        }
    }

    public func addFullsizeSubViewWithAutoLayout(_ view: UIView) {

        view.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right, .bottom]
        let constraints = attributes.map { (attribute) -> NSLayoutConstraint in
            NSLayoutConstraint(
                item: view,
                attribute: attribute,
                relatedBy: .equal,
                toItem: self,
                attribute: attribute,
                multiplier: 1.0,
                constant: 0
            )
        }
        addSubview(view)
        addConstraints(constraints)
    }

    public func addFullsizeSubViewWithAutoResizeMask(_ view: UIView) {
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
    }

    public func filterSubviews(_ pred: (UIView) throws -> Bool) rethrows  -> [UIView] {
        var result: [UIView] = []
        for subview in self.subviews {
            if try pred(subview) {
                result.append(subview)
            }
            result.append(contentsOf: try subview.filterSubviews(pred))
        }
        return result
    }

    public var firstResponderSubview: UIView? {
        let firstresponders = filterSubviews { $0.isFirstResponder }
        return firstresponders.first
    }

    public func wrapped<V: UIView>(with view: V) -> V {
        view.addFullsizeSubView(self)
        return view
    }

    public func adjustSizeForNavigationItemTitleView() {
        // https://goo.gl/l1QGCT
        translatesAutoresizingMaskIntoConstraints = false
        layoutIfNeeded()
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = true
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    public func hiddenSubviews(_ bool: Bool) {
        func hidden(_ views: [UIView], _ isHidden: Bool) {
            views.forEach { view in
                view.isHidden = isHidden
                hidden(view.subviews, isHidden)
            }
        }
        isHidden = bool
        hidden(subviews, bool)
    }

    public func showSubViews(_ bool: Bool) {
        func show(_ views: [UIView]) {
            views.forEach { view in
                view.isHidden = false
                show(view.subviews)
            }
        }
        if bool {
            isHidden = false
            show(subviews)
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = (newValue > 0)
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
}
