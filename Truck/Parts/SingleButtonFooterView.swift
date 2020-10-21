import UIKit

class SingleButtonFooterView: UITableViewHeaderFooterView {
    let button = UIButton()
    var buttonClosure: (()->())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    
        contentView.addSubview(button)
        contentView.backgroundColor = .white
        button.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.centerY.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalToSuperview().offset(10)
        })
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
    }
    
    @objc
    func buttonSelector() {
        guard let closure = buttonClosure else {
            return
        }
        closure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
