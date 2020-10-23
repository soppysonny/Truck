import UIKit

class IncomeHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        let titles = ["装点", "卸点", "公里", "单价", "价格"]
        for (_, element) in titles.enumerated() {
            stackView.addArrangedSubview(label(title: element))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func label(title: String) -> UILabel {
        let label = UILabel()
        label.textColor = .fontColor_black_153
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.text = title
        return label
    }
    
}
