import UIKit
import PromiseKit

public func defaultNavigationController(root: UIViewController) -> UINavigationController {
    let nav = defaultNavigationController()
    nav.viewControllers = [root]
    return nav
}

public func defaultNavigationController() -> UINavigationController {
    var nav = UINavigationController()
    defaultNavigationController(nav: &nav)
    return nav
}

public func defaultNavigationController(nav: inout UINavigationController) {
    nav.navigationBar.barTintColor = .white
    nav.view.backgroundColor = .white
    nav.navigationBar.backgroundColor = nil
    nav.navigationBar.isTranslucent = false
    nav.navigationBar.tintColor = UIColor.navTintColor
    nav.navigationBar.barStyle = .default    
    nav.navigationBar.barTintColor = UIColor.navBarTintColor
    nav.navigationBar.shadowImage = UIImage()    
}

func makeNavigationBarTransparent(navigationController: inout UINavigationController, navigationItem: inout UINavigationItem) {
    navigationController.navigationBar.isTranslucent = true
    navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController.navigationBar.shadowImage = UIImage()
    navigationItem.titleView = nil
    navigationItem.hidesBackButton = true
}

@available(*, deprecated, message: "modalableNavigationControllerは使わないことにします")
public func modalableNavigationController(root: UIViewController) -> BaseNavigationController {
    let nav = modalableNavigationController()
    nav.viewControllers = [root]
    return nav
}

@available(*, deprecated, message: "modalableNavigationControllerは使わないことにします")
public func modalableNavigationController() -> BaseNavigationController {
    let nav = BaseNavigationController()

    nav.navigationBar.barTintColor = .white
    nav.view.backgroundColor = .white
    nav.navigationBar.isTranslucent = false
    nav.navigationBar.tintColor = UIColor.navTintColor
    nav.navigationBar.barTintColor = UIColor.navBarTintColor
    return nav
}

public func fullScreenWindow() -> UIWindow {
    return UIWindow(frame: UIScreen.main.bounds)
}

public class BaseNavigationController: UINavigationController, ModalPromisable {
    public let (promise, resolver) = Promise<Any>.pending()

    /// 画面遷移アニメーションをカスタマイズする場合に指定する
    // swiftlint:disable:next weak_delegate
    public var customTransitionDelegate: UIViewControllerTransitioningDelegate?

    public func showModal(from viewController: UIViewController, presentingCompletion: (() -> Void)? = nil) {
        let present = self
        present.modalPresentationStyle = .currentContext
        present.modalTransitionStyle = .coverVertical
        viewController.present(present, animated: true, completion: nil)
    }
}

class AnyViewController: UIViewController {
    let customView: UIView
    init(view: UIView) {
        customView = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = customView
    }
}

public func viewController(_ view: UIView) -> UIViewController {
    return AnyViewController(view: view)
}

//デバッグ用のボタンがついてるView
public class ButtonView: UIView {
    let button = UIButton(type: .system)
    public var onTap:(() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        button.setTitle("タップ", for: .normal)
        self.addFullsizeSubView(button)
        button.addAction(events: .touchUpInside) {[unowned self] _ in
            self.onTap?()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//デバッグ用のボタンがついてるVC
public class ButtonViewController: UIViewController {

    let button = UIButton(type: .system)

    public var onTap:(() -> Void)?

    public override func loadView() {
        let buttonView = ButtonView()
        buttonView.onTap = {[unowned self] in
            self.onTap?()
        }
        view = buttonView
    }

    public init(onTap: @escaping () -> Void) {
        super.init(nibName: nil, bundle: nil)
        self.onTap = onTap
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}

public func collectionStackView(views: [UIView],
                                chunkSize: Int,
                                verticalSpace: CGFloat,
                                horizontalSpace: CGFloat) -> UIStackView {
    let verticalStackView = UIStackView()
    verticalStackView.axis = .vertical
    verticalStackView.alignment = .fill
    verticalStackView.distribution = .fill
    verticalStackView.spacing = verticalSpace
    let chunkedViews = views.chunked(chunkSize, fillWith: UIView.init)
    let horizontalStackViews = chunkedViews.map {(columns: [UIView]) -> UIStackView in
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = horizontalSpace
        columns.forEach(horizontalStackView.addArrangedSubview)
        return horizontalStackView
    }
    horizontalStackViews.forEach(verticalStackView.addArrangedSubview)
    return verticalStackView
}

