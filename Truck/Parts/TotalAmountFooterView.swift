import UIKit

class TotalAmountFooterView: UIView {
    let amountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let label = UILabel()
        addSubview(label)
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(13)
        })
        label.font = .systemFont(ofSize: 12)
        label.text = "合计"
        
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(40)
            make.top.equalTo(label.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-10)
        })
        amountLabel.font = .systemFont(ofSize: 18)
        amountLabel.textColor = #colorLiteral(red: 0.09803921569, green: 0.7725490196, blue: 0.4509803922, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
