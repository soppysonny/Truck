import UIKit

protocol ReportHeaderViewProtocol: class {
    func tapLeftTimeLabel()
    func tapRightTimeLabel()
    func buttonTapped()
}

class ReportHeaderView: UIView {
    let label_1 = UILabel()
    let label_2 = UILabel()
    let button = UIButton()
    weak var delegate:ReportHeaderViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(label_1)
        addSubview(label_2)
        label_1.textAlignment = .center
        label_2.textAlignment = .center
        addSubview(button)
        label_1.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(100)
        })
        
        let midLb = UILabel()
        midLb.text = " —— "
        addSubview(midLb)
        midLb.snp.makeConstraints({ make in
            make.centerY.equalToSuperview().offset(-1)
            make.left.equalTo(label_1.snp.right)
            make.right.equalTo(label_2.snp.left)
        })
        
        label_2.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        })
        label_1.font = .systemFont(ofSize: 14)
        label_2.font = .systemFont(ofSize: 14)
        

        button.snp.makeConstraints({ make in
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        })
        button.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitle("查询", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonSel), for: .touchUpInside)
        
        label_1.isUserInteractionEnabled = true
        label_2.isUserInteractionEnabled = true
        
        label_1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(leftLabelTapped)))
        label_2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(rightLabelTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func buttonSel() {
        delegate?.buttonTapped()
    }
    
    @objc
    func leftLabelTapped() {
        delegate?.tapLeftTimeLabel()
    }
    
    @objc
    func rightLabelTapped() {
        delegate?.tapRightTimeLabel()
    }
}
