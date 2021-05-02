import UIKit

class TaskDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {//}, MAMapViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch type {
        case .map:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell") as? MapTableViewCell else {
                return UITableViewCell()
            }
            if let lat = task?.upLat,
               let lon = task?.upLng {
                let upLoc = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(lon))
                let pointAnnotation = BMKPointAnnotation()
                pointAnnotation.coordinate = upLoc
                pointAnnotation.title = "qidian"
//                cell.mapView.setZoomLevel(14, animated: true)
//                cell.mapView.centerCoordinate = upLoc
                cell.mapView.addAnnotation(pointAnnotation)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            switch type {
            case .platenum(let value):
                cell.infoLabel.text = value
            case .up(let value):
                cell.infoLabel.text = value
            case .uptel(let value):
                cell.infoLabel.text = value
                cell.infoLabel.setPhoneStyle()
            case .upaddr(let value):
                cell.infoLabel.text = value
            case .date(let value):
                cell.infoLabel.text = value
            default:
                cell.titleLabel.text = cell.titleLabel.text
            }
            return cell
        }
    }
    
    enum CellType {
        case platenum(value: String)
        case up(value: String)
        case uptel(value: String)
        case upaddr(value: String)
        case date(value: String)
        case map
        func title() -> String {
            switch self {
            case .platenum:
                return "车牌号"
            case .up:
                return "装点"
            case .uptel:
                return "装点电话"
            case .upaddr:
                return "装点地址"
            case .date:
                return "日期"
            case .map:
                return ""
            }
        }
        
        static func types(task: MyTaskRow) -> [CellType] {
            var arr = [CellType]()
            if let plate = task.vehiclePlateNum {
                arr.append(.platenum(value: plate))
            }
            if let up = task.upAddressName {
                arr.append(.up(value: up))
            }
            if let uptel = task.phonenumber {
                arr.append(.uptel(value: uptel))
            }
            if let upaddr = task.upWord {
                arr.append(.upaddr(value: upaddr))
            }
            if let date = task.dispatchStartTime {
                arr.append(.date(value: date))
            }
            if task.upLat != nil && task.upLng != nil {
                arr.append(.map)
            }
            return arr
        }
        
    }
    enum ButtonSelectorType {
        case rejectTask
        case confirmTask
        case arrive
    }
    var tableView = UITableView()
    var cellTypes = [CellType]()
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var leftButtonSelType: ButtonSelectorType?
    var rightButtonSelType: ButtonSelectorType?
    
    @IBOutlet weak var stackView: UIStackView!
    var task: MyTaskRow?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "任务详情"
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(MapTableViewCell.self, forCellReuseIdentifier: "MapTableViewCell")
        tableView.snp.makeConstraints({ make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top)
        })
        if let row = self.task {
            cellTypes = CellType.types(task: row)
            tableView.reloadData()
        }
        
        guard let post = LoginManager.shared.user?.post,
           let postType = post.postType else {
            return
        }
        switch postType {
        case .truckDriver:
            guard task?.dispatchStartTime?.toDate(format: DateFormat.debug2, locale: "zh_CN")?.isToday == true ||
                  task?.dispatchStartTime?.toDate(format: DateFormat.debug, locale: "zh_CN")?.isToday == true ||
                (self.navigationController != nil && self.navigationController!.viewControllers.count <= 1) else {
                leftButton.isHidden = true
                rightButton.isHidden = true
                return
            }
            if task?.status == "0" {
                leftButton.isHidden = false
                rightButton.isHidden = true
//                rightButton.isHidden = false
                leftButton.setTitle("接受", for: .normal)
//                rightButton.setTitle("拒绝", for: .normal)
                leftButtonSelType = .confirmTask
//                rightButtonSelType = .rejectTask
            } else if task?.status == "1" {
                if task?.orderFlag == "0" {
                    rightButton.isHidden = true
                    leftButton.isHidden = false
                    leftButton.setTitle("已经到达", for: .normal)
                    leftButtonSelType = .arrive
                } else {
                    rightButton.isHidden = true
                    leftButton.isHidden = true
                }
            } else if task?.status == "2" {
                rightButton.isHidden = true
                leftButton.isHidden = true
            }
        case .siteManager:
            if task?.status == "0" {
                leftButton.isHidden = false
                leftButton.setTitle("接受", for: .normal)
                rightButton.isHidden = true
                rightButton.setTitle("拒绝", for: .normal)
                leftButtonSelType = .confirmTask
                rightButtonSelType = .rejectTask
            } else {
                rightButton.isHidden = true
                leftButton.isHidden = true
            }
        default:
            rightButton.isHidden = true
            leftButton.isHidden = true
            break
        }
    }
    
    @IBAction func leftButtonSel(_ sender: Any) {
        guard let left = leftButtonSelType else {
            return
        }
        showAlert(left)
    }
    
    @IBAction func rightButtonSel(_ sender: Any) {
        guard let right = rightButtonSelType else {
            return
        }
        showAlert(right)
    }
    
    func showAlert(_ type: ButtonSelectorType) {
        if type == .rejectTask {
            showRejectAlert(confirmClosure: {
                [weak self] reason in
                    self?.handleOrder(0, reason: reason)
            }, title: "请选择理由")
            return
        }
        var title = ""
        var confirmClosure: (()->())?
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        switch type {
        case .arrive:
            title = "是否已经到场？"
            confirmClosure = { [weak self] in
                self?.arrive()
            }
        case .confirmTask:
            title = "是否接受任务？"
            confirmClosure = { [weak self] in
                self?.handleOrder(1)
            }
        case .rejectTask:
            title = "是否拒绝任务？"
            alert.addTextField(configurationHandler: { textfield in
                textfield.placeholder = "请输入理由"
            })
            confirmClosure = { [weak self] in
                guard let reason = alert.textFields?.first?.text,
                      reason.count > 0 else {
                    self?.view.makeToast("请输入理由")
                    return
                }
                self?.handleOrder(0, reason: reason)
            }
        }
        alert.title = title
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: { [weak alert] _ in
            alert?.dismiss(animated: true, completion: nil)
        })
        let confirmAction = UIAlertAction.init(title: "确认", style: .default, handler: { [weak alert, confirmClosure] _ in
            alert?.dismiss(animated: true, completion: nil)
            confirmClosure?()
        })
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func handleOrder(_ status: Int, reason: String? = nil) {
        if status == 1 {
            guard let task = task,
                  let dispatchStartTime = task.dispatchStartTime,
                  let userId = LoginManager.shared.user?.user.userId else {
                return
            }
            var vehicleId = task.vehicleId
            if let type = LoginManager.shared.user?.post.postType,
               type == .siteManager {
                vehicleId = ""
            }
            
            Service.shared.acceptTask(dispatchId: task.id ?? "", dispatchStartTime: dispatchStartTime, userId: userId, vehicleId: vehicleId).done { [weak self] result in
                switch result {
                case .success(_):
                    UIApplication.shared.keyWindow?.makeToast("已接受任务")
                    if let count = self?.navigationController?.viewControllers.count,
                       count > 1 {
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    break
                case .failure(let err):
                    self?.view.makeToast(err.msg ?? "")
                    break
                }
            }.catch { [weak self] error in
                self?.view.makeToast(error.localizedDescription)
            }
        } else {
            guard let task = task,
                  let userId = LoginManager.shared.user?.user.userId else {
                return
            }
            guard let reason = reason else {
                self.view.makeToast("请输入理由")
                return
            }
            Service.shared.refuseTask(dispatchId: task.id ?? "", userId: userId, reason: reason).done{ [weak self] result in
                switch result {
                case .success(_):
                    self?.view.makeToast("已拒绝任务")
                    if let count = self?.navigationController?.viewControllers.count,
                       count > 1 {
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    break
                case .failure(let err):
                    self?.view.makeToast(err.msg ?? "")
                    break
                }
            }.catch { [weak self] error in
                self?.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    func arrive() {
        guard let task = task,
              let uid = LoginManager.shared.user?.user.userId,
              let location = LocationManager.shared.currentLocation
              else {
            return
        }
        let lng = Double(location.coordinate.longitude)
        let lat = Double(location.coordinate.latitude)
        Service.shared.arrive(req: ArriveUpRequest.init(dispatchId: task.id ?? "", userId: uid, lng: lng, lat: lat)).done { [weak self] result in
            switch result {
            case .success:
                UIApplication.shared.keyWindow?.makeToast("操作成功")
                self?.navigationController?.popViewController(animated: true)
            case .failure(let err):
                UIApplication.shared.keyWindow?.makeToast(err.msg ?? "操作失败")
            }
        }.catch { error in
            UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
        }
    }
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if let pinview = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")  {
//            pinview.image = UIImage.init(named: "qidian")
//            return pinview
//        } else {
//            if let pinview = MAAnnotationView.init(annotation: annotation, reuseIdentifier:"pin") {
//                pinview.image = UIImage.init(named: "qidian")
//                return pinview
//            } else {
//                return MAAnnotationView()
//            }
//        }
//
//    }
}
