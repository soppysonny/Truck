import UIKit

class GasDetailViewController: BaseViewController {
    
    enum CellType {
        case carInfo
        case driverInfo
        case price
        case gasAmount
        case total
        case uploadImage
        
        static func types() -> [CellType] {
            return [
                .carInfo,
                .driverInfo,
                .price,
                .gasAmount,
                .total,
                .uploadImage
            ]
        }
        
        func title() -> String {
            switch self {
            case .carInfo:
                return "车辆信息"
            case .driverInfo:
                return "司机信息"
            case .price:
                return "单价"
            case .gasAmount:
                return "加油量"
            case .total:
                return "总价"
            case .uploadImage:
                return "上传图片"
            }
        }

        func placeHolder() -> String {
            switch self {
            case .carInfo:
                return "请选择" + title()
            case .driverInfo:
                return "请选择" + title()
            case .price:
                return "请输入" + title() + "（元）"
            case .gasAmount:
                return "请输入" + title()
            case .total:
                return "请输入" + title() + "（元）"
            case .uploadImage:
                return "上传图片"
            }
        }
        
    }
    
    let tableView = UITableView()
    let cellTypes = CellType.types()
    let footerButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(UINib.init(nibName: "FormSelectTableViewCell", bundle: .main), forCellReuseIdentifier: "FormSelectTableViewCell")
        tableView.register(UINib.init(nibName: "FormInputTableViewCell", bundle: .main), forCellReuseIdentifier: "FormInputTableViewCell")
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        
        footerButton.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        footerButton.backgroundColor = .systemBlue
        footerButton.setTitleColor(.white, for: .normal)
        footerButton.setTitle("加油", for: .normal)
        footerButton.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
        
    }
    
    @objc
    func buttonSelector() {
        
    }
    
}

extension GasDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch type {
        case .carInfo, .driverInfo:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title() + ":"
            cell.defaultInfoText = type.placeHolder()
            cell.defaultAlertText = "没有可选的" + type.title()
            return cell
        case .price, .gasAmount, .total:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textField.placeholder = type.placeHolder()
            return cell
        case .uploadImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }
    
    
}
