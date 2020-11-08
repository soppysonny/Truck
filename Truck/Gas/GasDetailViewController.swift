import UIKit

class GasDetailViewController: BaseViewController {
    var gasRecord: GetOilOutByCreateByElement?
    enum CellType {
        case carInfo
        case driverInfo
        case gasType
        case price
        case gasAmount
        case total
        case uploadImage
        case rejectReasn
        
        static func types(gasRecord: GetOilOutByCreateByElement?) -> [CellType] {
            guard let record = gasRecord else {
                return []
            }
            let hasImage = record.imageList?.count != 0
            var types: [CellType] = [
                .carInfo,
                .driverInfo,
                .gasType,
                .price,
                .gasAmount,
                .total,
            ]
            if hasImage {
                types.append(.uploadImage)
            }
            if gasRecord?.status == "2" || gasRecord?.status == "3" {
                types.append(.rejectReasn)
            }
            return types
        }
        
        func title() -> String {
            switch self {
            case .carInfo:
                return "车辆信息"
            case .driverInfo:
                return "司机信息"
            case .gasType:
                return "加油类型"
            case .price:
                return "单价"
            case .gasAmount:
                return "加油量"
            case .total:
                return "总价"
            case .uploadImage:
                return "图片"
            case .rejectReasn:
                return "驳回理由"
            }
        }

        func placeHolder() -> String {
            switch self {
            case .carInfo:
                return "请选择" + title()
            case .driverInfo:
                return "请选择" + title()
            case .gasType:
                return "请输入" + title()
            case .price:
                return "请输入" + title() + "（元）"
            case .gasAmount:
                return "请输入" + title()
            case .total:
                return "请输入" + title() + "（元）"
            case .uploadImage:
                return "图片"
            case .rejectReasn:
                return "请输入驳回理由"
            }
        }
        
    }
    
    let tableView = UITableView()
    var cellTypes = [CellType]()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "加油"
        view.addSubview(tableView)
        view.addSubview(stackView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        tableView.register(UINib.init(nibName: "FormTextViewTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTextViewTableViewCell")
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        cellTypes = CellType.types(gasRecord: gasRecord)
        reloadButtons()
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

    func reloadButtons() {
        
        stackView.removeAllArrangedSubviews()
        for (_, element) in stackView.subviews.enumerated() {
            element.removeFromSuperview()
        }
        guard let gasRecord = gasRecord,
              let status = gasRecord.status,
              let post = LoginManager.shared.user?.post.postType else {
            stackView.snp.remakeConstraints({ make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
            })
            return
        }
        switch status {
        case "0" where post == .truckDriver:
            stackView.addArrangedSubview(button(true))
            stackView.addArrangedSubview(button(false))
        default:
            break
        }
    }
    
    func button(_ isConfirm: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(isConfirm ? "确认出库" : "驳回出库", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = isConfirm ? .confirmColor : .refuseColor
        button.cornerRadius = 7
        button.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        button.addTarget(self, action: isConfirm ? #selector(buttonSelector) : #selector(reject), for: .touchUpInside)
        return button
    }

    @objc
    func reject() {
        showInputAlert(confirmClosure: { [weak self] text in
            guard let reason = text,
                  reason.count > 0 else {
                self?.view.makeToast("请输入理由")
                return
            }
            self?.rejectRequest(reason: reason)
        }, title: "请输入驳回理由", placeholder: "请输入驳回理由")
    }

    func rejectRequest(reason: String) {
        guard let oilOutId = gasRecord?.id else {
            return
        }
        Service.shared.rejectOilOut(req: RejectOilOutRequest.init(oilOutId: oilOutId, rejectReason: reason)).done { [weak self] result in
            switch result {
            case .success(let resp):
                UIApplication.shared.keyWindow?.makeToast(resp.msg ?? "操作成功")
                self?.navigationController?.popViewController(animated: true)
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch { error in
            self.view.makeToast("请求失败" + error.localizedDescription)
        }
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
        case .rejectReasn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextViewTableViewCell") as? FormTextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
//            cell.textView.placeholder = NSString.init(string: type.placeHolder())
            cell.textView.isEditable = false
            cell.textView.text = gasRecord?.rejectReason
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
            case .driverInfo:
                cell.infoLabel.text = gasRecord.driverName
            case .gasType:
                cell.infoLabel.text = gasRecord.oilType
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
