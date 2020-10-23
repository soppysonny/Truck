import UIKit

class ReportTableHeaderView: UIView {
    let label_left = UILabel()
    let label_right = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        addSubview(label_left)
        addSubview(label_right)
        label_left.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(10)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(100)
        })
        label_left.textColor = .fontColor_black_153
        label_left.textAlignment = .left
        
        label_right.snp.makeConstraints({ make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(100)
        })
        label_right.textColor = .fontColor_black_153
        label_right.textAlignment = .right
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
