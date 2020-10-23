import UIKit
import SnapKit
import Toast_Swift
class LoginViewController: BaseViewController {
    let phoneNumTextField = UITextField()
    let adTF = UITextField()
    let pwTF = UITextField()
    let container = UIView()
    let loginBt = UIButton()
    var isMenuPending = false
    var isMenuShown = false
    var selectedIndexPath: IndexPath?
    var companyList: ListedCompanies? {
        didSet {
            if isMenuPending {
                self.showCompanyListMenu()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObervingEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登陆"
        view.addSubview(container)
        container.frame = view.bounds
        
        let headerImgView = UIImageView()
        container.addSubview(headerImgView)
        headerImgView.contentMode = .scaleAspectFill
        headerImgView.image = #imageLiteral(resourceName: "img")
        let height = (UIScreen.main.bounds.width - 40) * (36 / 67.0)
        headerImgView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(height)
            make.top.equalToSuperview()
        })
        
        phoneNumTextField.borderStyle = .roundedRect
        phoneNumTextField.keyboardType = .phonePad
        phoneNumTextField.leftViewMode = .always
        
        let pnLeftImgView = UIImageView(image: #imageLiteral(resourceName: "login_phone"))
        let pnleftView = UIView.init()
        pnleftView.addSubview(pnLeftImgView)
        phoneNumTextField.leftView = pnleftView
        pnleftView.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        pnLeftImgView.snp.makeConstraints({ make in
            make.centerY.centerX.equalToSuperview()
        })
        
        phoneNumTextField.placeholder = "请输入手机号码"
        container.addSubview(phoneNumTextField)
        phoneNumTextField.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headerImgView.snp.bottom).offset(40)
            make.height.equalTo(44)
        })
        
        
        adTF.borderStyle = .roundedRect
        let adLeftImgView = UIImageView(image: #imageLiteral(resourceName: "login_location"))
        let adleftView = UIView()
        adTF.leftView = adleftView
        adleftView.addSubview(adLeftImgView)
        adleftView.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        adLeftImgView.snp.makeConstraints({ make in
            make.centerY.centerX.equalToSuperview()
        })
        
        adTF.placeholder = "请输入地址"
        adTF.leftViewMode = .always
        container.addSubview(adTF)
        adTF.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(18)
            make.height.equalTo(44)
        })
        let adRightView = UIView()
        let adRightImgView = UIImageView.init(image: #imageLiteral(resourceName: "arrow_black_down"))
        adRightView.addSubview(adRightImgView)
        adTF.rightView = adRightView
        adRightView.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        adRightImgView.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
        })
        adTF.rightViewMode = .always
        adTF.delegate = self
        pwTF.borderStyle = .roundedRect
        let pwLeftImgView = UIImageView(image: #imageLiteral(resourceName: "login_lock"))
        let pwleftView = UIView()
        pwTF.leftView = pwleftView
        pwleftView.addSubview(pwLeftImgView)
        pwleftView.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        pwLeftImgView.snp.makeConstraints({ make in
            make.centerY.centerX.equalToSuperview()
        })
        pwTF.borderStyle = .roundedRect
        pwTF.leftViewMode = .always
        pwTF.isSecureTextEntry = true
        pwTF.placeholder = "请输入密码"
        container.addSubview(pwTF)
        pwTF.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(adTF.snp.bottom).offset(18)
            make.height.equalTo(44)
        })
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(resignResponding))
        view.addGestureRecognizer(gesture)
        gesture.delegate = self
        
        container.addSubview(loginBt)
        loginBt.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(pwTF.snp.bottom).offset(86)
        })
        loginBt.cornerRadius = 5
        loginBt.backgroundColor = #colorLiteral(red: 0.2392156863, green: 0.5490196078, blue: 0.8235294118, alpha: 1)
        loginBt.setTitleColor(.white, for: .normal)
        loginBt.setTitle("登陆", for: .normal)
        loginBt.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        requestCompanyList()
    }
    
    @objc
    func resignResponding() {
        if phoneNumTextField.isFirstResponder {
            phoneNumTextField.resignFirstResponder()
        }
        if adTF.isFirstResponder {
            adTF.resignFirstResponder()
        }
        if pwTF.isFirstResponder {
            pwTF.resignFirstResponder()
        }
    }
    
    func getRespondingTf() -> UITextField? {
        if phoneNumTextField.isFirstResponder {
            return phoneNumTextField
        }
        if adTF.isFirstResponder {
            return adTF
        }
        if pwTF.isFirstResponder {
            return pwTF
        }
        return nil
    }
    
    override func handleUIKeyboardWillShowNotification(notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curveValue = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        let curve = UIView.AnimationOptions(rawValue: curveValue)
        guard let tf = getRespondingTf() else {
            return
        }
        let tf_bottom = container.frame.size.height - tf.frame.maxY
        let keyboardRange = UIScreen.main.bounds.height - frame.origin.y
        let move = keyboardRange - tf_bottom
        guard move > 0 else {
            return
        }
        UIView.animate(withDuration: duration, delay: 0, options: [curve], animations: { [weak self] in
            guard let self = self else { return }
            self.container.frame = CGRect.init(x: 0, y: -move, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }, completion: nil)
    }
    
    override func handleUIKeyboardWillHideNotification(notification: Notification) {
        self.container.frame = view.bounds
    }
    
    @objc
    func login() {
        guard let phone = phoneNumTextField.text else {
            view.makeToast("请输入手机号码")
            return
        }

        guard let indexpath = selectedIndexPath,
            let companylist = companyList else {
                view.makeToast("请选择地址")
            return
        }

        guard let pw = pwTF.text,
            pw.count != 0 else {
            view.makeToast("请输入密码")
            return
        }
        
        let company = companylist[indexpath.row]
        Service().login(phone: phone, area: company.companyId, password: pw).done { [weak self] result in
            print(result)
            switch result {
            case .success(let resp):
                resp.data?.saveToDefaults().done { result in
                    print(result)
                    LoginManager.shared.setup()
                }.catch{ [weak self] error in
                    self?.view.makeToast("登陆信息保存失败")
                }
            case .failure(let error):
                self?.view.makeToast("登陆失败:\(error.msg ?? ""), code: \(error.code)")
                break
            }
        }.catch { error in
            // TODO
            print(error)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        resignResponding()
        showCompanyListMenu()
        return false
    }
}

extension LoginViewController {
    func requestCompanyList() {
        Service().companyList().done{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.companyList = response.data
            case .failure(let error):
                self.view.makeToast("\(error.msg ?? "")")
                if self.isMenuPending {
                    self.isMenuPending = false
                }
                break
            }
        }.catch { error in
            if self.isMenuPending {
                self.isMenuPending = false
            }
            print(error)
        }
    }
    
    func showCompanyListMenu() {
        if isMenuPending {
            return
        }
        guard let companyList = companyList else {
            isMenuPending = true
            requestCompanyList()
            return
        }
        guard isMenuShown == false else {
            return
        }
        var items = [String]()
        _ = companyList.map {
            items.append("\($0.alias ?? "")")
        }
        DropDownMenu.showWithTitles(items, attachedView: adTF, height: 200, delegate: self, selectedIndexPath: selectedIndexPath)
        isMenuShown = true
        
    }
}

extension LoginViewController: DropDownMenuProtocol {
    func selected(indexPath: IndexPath) {
        isMenuShown = false
        selectedIndexPath = indexPath
        guard let companyList = companyList else {
                return
        }
        adTF.text = companyList[indexPath.row].alias
    }
    
    func deselected() {
        selectedIndexPath = nil
    }
    
    func dismissed() {
        isMenuShown = false
    }
    
}

extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UITableView || touch.view is UITableViewCell || touch.view?.superview is UITableViewCell)
    }
}
