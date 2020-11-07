import UIKit
import PromiseKit
enum OrderDetailRowType {
    case numberPlate(_ value: String?)
    case driverName(_ value: String?)
    case loadLocation(_ value: String?)
    case loadLocationTel(_ value: String?)
    case loadLocationAddr(_ value: String?)
    case loadLocationManager(_ value: String?)
    case unloadLocation(_ value: String?)
    case unloadLocationTel(_ value: String?)
    case unloadLocationAddr(_ value: String?)
    case unloadLocationContact(_ value: String?)
    
    func title() -> String {
        switch self {
        case .numberPlate: return "车牌号"
        case .driverName: return "司机"
        case .loadLocation: return "装点"
        case .loadLocationTel: return "装点电话"
        case .loadLocationAddr: return "装点地址"
        case .loadLocationManager: return "装点管理员"
        case .unloadLocation: return "卸点"
        case .unloadLocationTel: return "卸点电话"
        case .unloadLocationAddr: return "卸点地址"
        case .unloadLocationContact: return "卸点联系人"
        }
    }
    
    func value() -> String {
        switch self {
        case .numberPlate(let value): return value ?? ""
        case .driverName(let value): return value ?? ""
        case .loadLocation(let value): return value ?? ""
        case .loadLocationTel(let value): return value ?? ""
        case .loadLocationAddr(let value): return value ?? ""
        case .loadLocationManager(let value): return value ?? ""
        case .unloadLocation(let value): return value ?? ""
        case .unloadLocationTel(let value): return value ?? ""
        case .unloadLocationAddr(let value): return value ?? ""
        case .unloadLocationContact(let value): return value ?? ""
        }
    }
    
}
//1装车确认 2卸车确认 3转运申请 4现场管理员现场确认(设置卸点) 5转运确认 6正常完成确认 7异常申请 8异常上传图片
enum OrderDetailBottomButtonType: Int {
    case loadConfirm = 1
    case unloadConfirm
    case applyForTransfer
    
    case siteManagerConfirm
    case confirmTransfer
    
    case completeOrder
    case raiseException
    case uploadException
    
    func title() -> String {
        var title = ""
        switch self {
        case .loadConfirm:
            title = "装车确认"
        case .unloadConfirm:
            title = "卸车确认"
        case .applyForTransfer:
            title = "转运申请"
        case .siteManagerConfirm:
            title = "设置卸点"
        case .confirmTransfer:
            title = "转运确认"
        case .completeOrder:
            title = "完成运单"
        case .raiseException:
            title = "异常申请"
        case .uploadException:
            title = "异常上传"
        }
        return title
    }
    
}

class OrderDetailViewController: BaseViewController {
    let tableView = UITableView()
    var rowTypes = [OrderDetailRowType]()
    var stackView = UIStackView()
    var buttonTypes = [OrderDetailBottomButtonType]()
    
    var task: WorkbenchListElement?
    var orderDetail: OrderDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "任务详情"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: "MapTableViewCell")
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(40)
        })
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        requestOrderDetail().done { [weak self] data in
            self?.orderDetail = data
            self?.setupLayoutRows()
            self?.configStackView()
            self?.tableView.reloadData()
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
        
    }
    
    override func reloadInfoOnAppear() {
        requestOrderDetail().done { [weak self] data in
            self?.orderDetail = data
            self?.setupLayoutRows()
            self?.configStackView()
            self?.tableView.reloadData()
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
    
    func requestOrderDetail() -> Promise<OrderDetailResponse> {
        let (promise, resolver) = Promise<OrderDetailResponse>.pending()
        guard let task = self.task,
              let orderId = task.id else {
            resolver.reject(Errors.Empty)
            return promise
        }
        Service.shared.orderDetail(orderId: orderId).done { result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    resolver.reject(Errors.Empty)
                    return
                }
                resolver.fulfill(data)
            case .failure(let err):
                resolver.reject(Errors.requestError(message: err.msg ?? "", code: err.code))
            }
        }.catch { error in
            resolver.reject(error)
        }
        return promise
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
    
    func reloadBottomButtons() {
        if buttonTypes.count == 0 {
            stackView.isHidden = true
        } else {
            stackView.isHidden = false
        }
        stackView.removeAllArrangedSubviews()
        for (_, element) in buttonTypes.enumerated() {
            stackView.addArrangedSubview(buttonWithType(type: element))
        }
    }
    
    func configStackView() {
        guard let postType = LoginManager.shared.user?.post.postType,
              let orderDetail = orderDetail else {
            return
        }
        switch postType {
        case .siteManager:
            if orderDetail.status == "0" {
                if orderDetail.isTransport == "1" {
                    buttonTypes = [.confirmTransfer]
                } else {
                    buttonTypes = [.siteManagerConfirm]
                }
            } else {
                buttonTypes = []
            }
        case .truckDriver:
            if orderDetail.status == "1" && orderDetail.isNormal == "0" {
                buttonTypes = [.completeOrder, .raiseException]
            } else if orderDetail.status == "1" && orderDetail.isNormal == "1" {
                buttonTypes = []
            } else if orderDetail.status == "1" && orderDetail.isNormal == "2" {
                buttonTypes = [.uploadException]
            } else {
                buttonTypes = []
                if orderDetail.upTime?.count == 0 || orderDetail.upTime == nil {
                    buttonTypes.append(.loadConfirm)
                } else {
                    buttonTypes.append(.unloadConfirm)
                }
                if orderDetail.downId != nil && orderDetail.transportAddress == nil {
                    buttonTypes.append(.applyForTransfer)
                }
            }
        default:
            break
        }
        reloadBottomButtons()
    }
    
    func buttonWithType(type: OrderDetailBottomButtonType) -> UIButton {
        let button = UIButton()
        let title = type.title()
        var backgroundColor = UIColor.systemBlue
        switch type {
        case .loadConfirm:
            backgroundColor = .systemBlue
        case .unloadConfirm:
            backgroundColor = .systemBlue
        case .applyForTransfer:
            backgroundColor = .systemOrange
        case .siteManagerConfirm:
            backgroundColor = .systemBlue
        case .confirmTransfer:
            backgroundColor = .systemBlue
        case .completeOrder:
            backgroundColor = .systemBlue
        case .raiseException:
            backgroundColor = .systemOrange
        case .uploadException:
            backgroundColor = .systemBlue
        }
        button.addTarget(self, action: selWithType(type), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.cornerRadius = 5
        return button
    }
    
    func selWithType(_ type: OrderDetailBottomButtonType) -> Selector {
        switch type {
        case .loadConfirm:
            return #selector(loadConfirm)
        case .unloadConfirm:
            return #selector(unloadConfirm)
        case .applyForTransfer:
            return #selector(applyForTransfer)
        case .siteManagerConfirm:
            return #selector(siteManagerConfirm)
        case .confirmTransfer:
            return #selector(confirmTransfer)
        case .completeOrder:
            return #selector(completeOrder)
        case .raiseException:
            return #selector(raiseException)
        case .uploadException:
            return #selector(uploadException)
        }
    }
    
//    func showAlertWithConfirmClosure(_ closure: @escaping ()->(Void), title: String) {
//        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
//        let action_cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: { [weak alert] _ in
//            alert?.dismiss(animated: true, completion: nil)
//        })
//        let action_confirm = UIAlertAction.init(title: "确认", style: .default, handler: { [weak alert] _ in
//            alert?.dismiss(animated: true, completion: nil)
//            closure()
//        })
//        alert.addAction(action_cancel)
//        alert.addAction(action_confirm)
//        present(alert, animated: true, completion: nil)
//    }
    
    @objc
    func loadConfirm() {
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self,
                  let orderDetail = self.orderDetail else {
                return
            }
            let operate = OrderOperateViewController.init(type: .loadConfirm, orderDetail: orderDetail)
            self.navigationController?.pushViewController(operate, animated: true)
        }, title: OrderDetailBottomButtonType.loadConfirm.title())
    }
    
    @objc
    func unloadConfirm() {
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self,
                  let orderDetail = self.orderDetail else {
                return
            }
            let operate = OrderOperateViewController.init(type: .unloadConfirm, orderDetail: orderDetail)
            self.navigationController?.pushViewController(operate, animated: true)
        }, title: OrderDetailBottomButtonType.unloadConfirm.title())
    }
    
    @objc
    func applyForTransfer() {
        //API
        guard let orderDetail = self.orderDetail,
              let orderId = orderDetail.id else {
            return
        }
        let type = 3
        let downId = orderDetail.downId
        Service.shared.orderOperation(downId: downId, imageList: nil, orderId: orderId, type: type).done { [weak self] result in
            switch result {
            case .success:
                self?.view.makeToast("操作成功")
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch({ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    
    @objc
    func siteManagerConfirm() {
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self,
                  let orderDetail = self.orderDetail else {
                return
            }
            let operate = OrderOperateViewController.init(type: .siteManagerConfirm, orderDetail: orderDetail)
            self.navigationController?.pushViewController(operate, animated: true)
        }, title: OrderDetailBottomButtonType.siteManagerConfirm.title())
    }
    
    @objc
    func confirmTransfer() {
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self,
                  let orderDetail = self.orderDetail else {
                return
            }
            let operate = OrderOperateViewController.init(type: .confirmTransfer, orderDetail: orderDetail)
            self.navigationController?.pushViewController(operate, animated: true)
        }, title: OrderDetailBottomButtonType.confirmTransfer.title())
    }
    
    @objc
    func completeOrder() {
        guard let orderDetail = self.orderDetail,
              let orderId = orderDetail.id else {
            return
        }
        let type = 6
        let downId = orderDetail.downId
        Service.shared.orderOperation(downId: downId, imageList: nil, orderId: orderId, type: type).done { [weak self] result in
            switch result {
            case .success:
                self?.view.makeToast("操作成功")
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch({ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    
    @objc
    func raiseException() {
        guard let orderDetail = self.orderDetail,
              let orderId = orderDetail.id else {
            return
        }
        let type = 7
        let downId = orderDetail.downId
        Service.shared.orderOperation(downId: downId, imageList: nil, orderId: orderId, type: type).done { [weak self] result in
            switch result {
            case .success:
                self?.view.makeToast("操作成功")
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch({ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    
    @objc
    func uploadException() {
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self,
                  let orderDetail = self.orderDetail else {
                return
            }
            let operate = OrderOperateViewController.init(type: .uploadException, orderDetail: orderDetail)
            self.navigationController?.pushViewController(operate, animated: true)
        }, title: OrderDetailBottomButtonType.uploadException.title())
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowTypes.count + 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == rowTypes.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell") as? MapTableViewCell else {
                return UITableViewCell()
            }
            
            cell.mapView.setZoomLevel(14, animated: true)
            if  let lat = self.orderDetail?.upLat,
                let lon = self.orderDetail?.upLng {
                let location = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(lon))
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = location
                cell.mapView.addAnnotation(pointAnnotation)
                cell.mapView.centerCoordinate = location
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
            return UITableViewCell()
        }
        let row = rowTypes[indexPath.row]
        switch row {
        case .loadLocationTel, .unloadLocationTel:
            cell.infoLabel.setPhoneStyle()
        default:
            cell.infoLabel.setNormalStyle()
            break
        }
        
        cell.titleLabel.text = row.title()
        cell.infoLabel.text = row.value()
        return cell
    }
    
}
