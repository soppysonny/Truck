import UIKit

class ButtonFooterView: UITableViewHeaderFooterView {
    let button = UIButton()
    let reviseButton = UIButton()
    var closure: (()->())?
    var revise: (()->())?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        contentView.backgroundColor = .white
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("退出登陆", for: .normal)
        button.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        })
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonSel), for: .touchUpInside)
        
        contentView.addSubview(reviseButton)
        reviseButton.backgroundColor = .homeVoiceButtonColor
        reviseButton.setTitleColor(.white, for: .normal)
        reviseButton.setTitle("修改密码", for: .normal)
        reviseButton.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        })
        reviseButton.layer.cornerRadius = 5
        reviseButton.addTarget(self, action: #selector(revicePW), for: .touchUpInside)
        
    }
    
    @objc
    func buttonSel() {
        guard let closure = closure else {
            return
        }
        closure()
    }
    
    @objc
    func revicePW() {
        guard let revise = revise else {
            return
        }
        revise()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
