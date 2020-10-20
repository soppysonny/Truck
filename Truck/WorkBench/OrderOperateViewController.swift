import UIKit

class OrderOperateViewController: BaseViewController {
    var type: OrderDetailBottomButtonType = .applyForTransfer
    let tableView = UITableView()
    let footerButton = UIButton()
    var rowTypes = [OrderDetailRowType]()
    var orderDetail: OrderDetailResponse? = nil
    var addressList: [ListAddressResponse]?
    
    var selectedAddr: ListAddressResponse?
    
    init(type: OrderDetailBottomButtonType, orderDetail: OrderDetailResponse) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        self.orderDetail = orderDetail
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type.title()
        setupLayoutRows()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
    
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(UINib.init(nibName: "FormSelectTableViewCell", bundle: .main), forCellReuseIdentifier: "FormSelectTableViewCell")
        
        view.addSubview(footerButton)
        footerButton.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        footerButton.backgroundColor = .systemBlue
        footerButton.setTitleColor(.white, for: .normal)
        footerButton.setTitle(type.title(), for: .normal)
        footerButton.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
        requestAddressList(addressType: "2")
    }

    func requestAddressList(addressType: String) {
        guard let orderDetail = orderDetail,
              let cid = orderDetail.companyId,
              let pid = orderDetail.projectId else {
            return
        }
        Service.shared.listAddress(addressType: addressType,
                                   companyId: cid,
                                   projectId: pid,
                                   userId: LoginManager.shared.user?.user.userId).done { [weak self] result in
                                    switch result {
                                    case .success(let resp):
                                        guard let addressList = resp.data else {
                                            return
                                        }
                                        self?.addressList = addressList
                                        self?.tableView.reloadData()
                                    default: break
                                    }
                                   }.cauterize()
    }
    
    @objc
    func buttonSelector() {
        
    }
    
    func setupLayoutRows() {
        guard let task = orderDetail  else {
            return
        }
        rowTypes = [
            .numberPlate(task.vehiclePlateNum),
            .driverName(task.driverName),
            .loadLocation(task.upName),
            .loadLocationTel(task.upPhone),
            .loadLocationAddr(task.upWord),
            .loadLocationManager(task.upManagerNickName),
            .unloadLocation(task.downName),
            .unloadLocationTel(task.downPhone),
            .unloadLocationAddr(task.downWord),
            .unloadLocationContact(task.linkman)
        ]
    }
    
}

extension OrderOperateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowTypes[indexPath.row]
        switch row {
        case .unloadLocation(_):
            if type == .siteManagerConfirm || type == .confirmTransfer {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                    return UITableViewCell()
                }
                cell.titleLabel.text = row.title()
                cell.infoLabel.text = selectedAddr?.addressName ?? "选择地址"
                cell.delegate = self
                if let addrList = self.addressList {
                    cell.titles = addrList.compactMap({
                        $0.addressName
                    })
                }
                return cell
            }
            break
        default:
           break
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = row.title()
        cell.infoLabel.text = row.value()
        return cell
    }
        
}

extension OrderOperateViewController: FormSelectDelegate {
    func didSelect(_ indexPath: IndexPath) {
        guard let addrList = addressList,
              let addr = addrList[safe: indexPath.row] else {
            return
        }
        selectedAddr = addr
    }
}
