import UIKit

class BaseViewController: UIViewController, KeyboardHelper {

    var hideSlideErrorAtTransition: Bool { return true }
    
    // KeyboardManager
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    var shouldReloadText = false;
    var viewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .white;
        let normalImage = #imageLiteral(resourceName: "nav_back_black")
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 22, height: 22))
        button.setImage(normalImage, for: .normal)
        button.addAction(events: .touchUpInside, navigationBackButtonAction)
        navigationItem.backBarButtonItem = UIBarButtonItem(customView: button)
    }
    func showAlertWithConfirmClosure(_ closure: @escaping ()->(Void), title: String) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let action_cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
        })
        let action_confirm = UIAlertAction.init(title: "确认", style: .default, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
            closure()
        })
        alert.addAction(action_cancel)
        alert.addAction(action_confirm)
        present(alert, animated: true, completion: nil)
    }
    
    func showInputAlert(confirmClosure: @escaping (String?)-> (Void), title: String, placeholder: String?) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let action_cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
        })
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "请输入理由"
        })
        let action_confirm = UIAlertAction.init(title: "确认", style: .default, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
            confirmClosure(alert?.textFields?.first?.text)
        })
        alert.addAction(action_cancel)
        alert.addAction(action_confirm)
        present(alert, animated: true, completion: nil)
        
    }
    
    func showRejectAlert(confirmClosure: @escaping (String?)-> (Void), title: String) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)
        let action_cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
        })
        let reasons = ["扣车",
                       "维修",
                       "事假",
                       "其他"
        ]
        reasons.forEach {
            let action = UIAlertAction(title: $0, style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                confirmClosure(action.title ?? "")
            })
            alert.addAction(action)
        }
        alert.addAction(action_cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func navigationBackButtonAction(_ sender: UIButton?) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldReloadText {
            loadText()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewDidAppear {
            reloadInfoOnAppear()
        }
        viewDidAppear = true
    }
    
    func reloadInfoOnAppear() {
        
    }
    
    func loadText() {
        /* set text for label/input/button/vc title or any part need localization */
    }
    
    @objc
    func reloadText() {
        guard isViewLoaded, view.window != nil else {
            shouldReloadText = true
            return
        }
        shouldReloadText = false
        loadText()
    }
    
    func handleUIKeyboardWillShowNotification(notification: Notification) { /* implement when needed */ }
    func handleUIKeyboardWillHideNotification(notification: Notification) { /* implement when needed */ }
    
    func presentImagePreviewer(image: UIImage) {
        
    }
    
}

