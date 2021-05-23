import Foundation

import Toast_Swift
enum BigFontAlertStyle {
    case plain
    case code(checkCode: String)
}
class BigFontAlertController: UIViewController, CodeFieldDelegate {
    let style: BigFontAlertStyle
    var container = UIView()
    var titleLabel = UILabel()
    var cancelButton = UIButton()
    var confirmButton = UIButton()
    
    var confirmBlock: (()->())?
    var cancelBlock: (()->())?
    var checkCode: String?
    var currentCode: String?
    
    lazy var textField: CodeField = {
        let tf = CodeField(frame: .zero)
        tf.delegate = self
        return tf
    }()
    func codeDidChanged(code: String) {
        currentCode = code
    }
    class func showAlert(style: BigFontAlertStyle,
                         title: String,
                         confirmBlock:(()->())?,
                         cancelBlock:(()->())? = nil,
                         fromVC: UIViewController) {
        let alert = BigFontAlertController(style: style)
        alert.titleLabel.text = title
        alert.confirmBlock = confirmBlock
        alert.cancelBlock = cancelBlock
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    init(style: BigFontAlertStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func confirm() {
        guard currentCode == checkCode else {
            self.view.makeToast("口令输入错误")
            return
        }
        dismiss(animated: true, completion: confirmBlock)
    }
    
    @objc
    func cancel() {
        dismiss(animated: true, completion: cancelBlock)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalTo(40)
        }
        container.layer.cornerRadius = 5
        container.backgroundColor = .white
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalTo(40)
            make.right.equalTo(-40)
        }
        titleLabel.numberOfLines = 0
        titleLabel.font = .boldSystemFont(ofSize: 27)
        container.addSubview(confirmButton)
        container.addSubview(cancelButton)
        confirmButton.setTitle("确认", for: .normal)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.backgroundColor = UIColor.tabbarTintColor
        confirmButton.layer.cornerRadius = 5
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.tabbarTintColor, for: .normal)
        cancelButton.layer.borderColor = UIColor.tabbarTintColor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 5
        
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 25)
        switch style {
        case .code(let checkCode):
            self.checkCode = checkCode
            container.addSubview(textField)
            
            textField.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(40)
                make.left.equalTo(40)
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
            }
            cancelButton.snp.makeConstraints { make in
                make.left.equalTo(40)
                make.right.equalTo(view.snp.centerX).offset(-20)
                make.bottom.equalToSuperview().offset(-40)
                make.height.equalTo(50)
                make.top.equalTo(textField.snp.bottom).offset(30)
            }
            confirmButton.snp.makeConstraints { make in
                make.right.equalTo(-40)
                make.left.equalTo(view.snp.centerX).offset(20)
                make.bottom.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        case .plain:
            cancelButton.snp.makeConstraints { make in
                make.left.equalTo(40)
                make.right.equalTo(view.snp.centerX).offset(-20)
                make.bottom.equalToSuperview().offset(-40)
                make.height.equalTo(50)
                make.top.equalTo(titleLabel.snp.bottom).offset(30)
            }
            confirmButton.snp.makeConstraints { make in
                make.right.equalTo(-40)
                make.left.equalTo(view.snp.centerX).offset(20)
                make.bottom.equalToSuperview().offset(-40)
                make.height.equalTo(50)
            }
        }
        
    }
}
