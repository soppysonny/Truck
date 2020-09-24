import UIKit
import SnapKit
class Alert: UIView {
    let titleLabel = UILabel()
    let containerView = UIView()
    let contentView = UIView()
    let cancelButton = UIButton()
    let confirmButton = UIButton()
    
    static func showAgreementAlert() {
        let alert = AgreementAlert.init(frame: UIScreen.main.bounds)
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
     
        window.addSubview(alert)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        
        containerView.backgroundColor = .white
        addSubview(containerView)
        containerView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(45)
            make.centerY.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(355)
        })
        
        
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(19)
        })
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .fontColor_black_51
        
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints({make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.5)
            make.left.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
        })
        
        let stackView = UIStackView()
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(25)
            make.centerX.equalTo(snp.centerX)
            make.bottom.equalToSuperview().offset(-30)
            make.top.equalTo(contentView.snp.bottom).offset(20)
        })
        stackView.axis = .horizontal
        stackView.spacing = 12.5
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
        cancelButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        confirmButton.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        
    }
    
    @objc
    func tap() {
        if superview != nil {
            removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError()
    }
}

class AgreementAlert: Alert {
    let gradientLayer = CAGradientLayer()
    let textView = UITextView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "隐私协议"
        cancelButton.setTitle("取消", for: .normal)
        confirmButton.setTitle("同意", for: .normal)
        cancelButton.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        cancelButton.layer.borderWidth = 0.5
        
        confirmButton.layer.cornerRadius = 5;
        confirmButton.setTitleColor(.white, for: .normal)
        
        confirmButton.layer.insertSublayer(gradientLayer, below: confirmButton.titleLabel?.layer)
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.colors = [#colorLiteral(red: 0.1294117647, green: 0.337254902, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.1490196078, green: 0.5725490196, blue: 1, alpha: 1).cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0), NSNumber.init(value: 1)]
        gradientLayer.cornerRadius = 5
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        textView.textColor = .fontColor_black_51
        textView.font = .systemFont(ofSize: 15)
        // TODO: 
        textView.text = "协议内容"
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientLayer.frame = confirmButton.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
