import UIKit

class GasDetailViewController: BaseViewController {
    var gasRecord: GetOilOutByCreateByElement?
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
                return "图片"
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
                return "图片"
            }
        }
        
    }
    
    let tableView = UITableView()
    let cellTypes = CellType.types()
    let footerButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加油"
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
        
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        
        view.addSubview(footerButton)
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
        footerButton.cornerRadius = 5
        
        footerButton.isHidden = gasRecord?.status != "0" || LoginManager.shared.user?.post.postType != .truckDriver
    }
    
    @objc
    func buttonSelector() {
        guard let oilid = gasRecord?.id else {
            return
        }
        showAlertWithConfirmClosure({ [weak self] in
            Service.shared.updateOilOutStatus(UpdateOilOutStatusRequest.init(oilOutId: oilid)).done { [weak self] result in
                switch result {
                case .success:
                    UIApplication.shared.keyWindow?.makeToast("操作成功")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let err):
                    self?.view.makeToast(err.msg)
                }
            }.catch({ [weak self] error in
                self?.view.makeToast(error.localizedDescription)
            })
        }, title: "确定油品出库？")
        
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
        case .uploadImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.configEditable(false)
            guard let images = gasRecord?.imageList else {
                return cell
            }
            cell.imageElements = images
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            guard let gasRecord = gasRecord else {
                return cell
            }
            switch type {
            case .carInfo:
                cell.infoLabel.text = gasRecord.plateNum
            case .price:
                cell.infoLabel.text = String.init(format: "%.1f", gasRecord.oilPrice ?? 0)
            case .gasAmount:
                cell.infoLabel.text = String.init(format: "%.1f", gasRecord.oilTonnage ?? 0)
            case .total:
                cell.infoLabel.text = String.init(format: "%.1f", gasRecord.total ?? 0)
            default: break
            }
            return cell
        }
    }
    
    
}
