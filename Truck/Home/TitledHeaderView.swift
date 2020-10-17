import UIKit

class TitledHeaderView: UITableViewHeaderFooterView {
    let titleLabel = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
        })
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.fontColor_black_51
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
