import UIKit

class ButtonFooterView: UITableViewHeaderFooterView {
    let button = UIButton()
    var closure: (()->())?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        contentView.backgroundColor = .white
        button.backgroundColor = .segmentControlTintColor
        button.setTitleColor(.white, for: .normal)
        button.setTitle("退出登陆", for: .normal)
        button.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.top.bottom.equalToSuperview().offset(10)
            make.centerY.centerX.equalToSuperview()
        })
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonSel), for: .touchUpInside)
    }
    
    @objc
    func buttonSel() {
        guard let closure = closure else {
            return
        }
        closure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
