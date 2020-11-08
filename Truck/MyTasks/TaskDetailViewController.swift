import UIKit
import AMapFoundationKit

class TaskDetailViewController: BaseViewController, MAMapViewDelegate {
    
    enum ButtonSelectorType {
        case rejectTask
        case confirmTask
        case arrive
    }
    
    @IBOutlet weak var numberPlateLb: UILabel!
    @IBOutlet weak var locationLb: UILabel!
    
    @IBOutlet weak var locationDetailLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var telephone: PhoneNumLabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    let mapView = MAMapView(frame: .zero)
    
    var leftButtonSelType: ButtonSelectorType?
    var rightButtonSelType: ButtonSelectorType?
    
    var task: MyTaskRow?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.setZoomLevel(14, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "任务详情"
        view.addSubview(mapView)
        mapView.snp.makeConstraints({ make in
            make.top.equalTo(dateLb.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo((UIScreen.main.bounds.width - 30) * 9 / 16.0)
        })
        mapView.delegate = self
        
        if let task = task {
            numberPlateLb.text = task.vehiclePlateNum
            locationLb.text = task.upAddressName
            telephone.text = task.phonenumber
            locationDetailLb.text = task.upWord
            dateLb.text = task.dispatchStartTime
            
            if let lat = task.upLat,
                let lon = task.upLng {
                let upLoc = CLLocationCoordinate2D.init(latitude: CLLocationDegrees.init(lat), longitude: CLLocationDegrees.init(lon))
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = upLoc
                pointAnnotation.title = "qidian"
                mapView.setZoomLevel(14, animated: true)
                mapView.centerCoordinate = upLoc
                mapView.addAnnotation(pointAnnotation)
            }
        }
        
        guard let post = LoginManager.shared.user?.post,
           let postType = post.postType else {
            return
        }
        switch postType {
        case .truckDriver:
            guard let date = task?.dispatchStartTime?.toDate(format: DateFormat.debug2, locale: "zh_CN"),
                  date.isToday else {
                leftButton.isHidden = true
                rightButton.isHidden = true
                return
            }
            if task?.status == "0" {
                leftButton.isHidden = false
                rightButton.isHidden = false
                leftButton.setTitle("接受", for: .normal)
                rightButton.setTitle("拒绝", for: .normal)
                leftButtonSelType = .confirmTask
                rightButtonSelType = .rejectTask
            } else {
                rightButton.isHidden = true
                leftButton.isHidden = false
                leftButton.setTitle("已经到达", for: .normal)
                leftButtonSelType = .arrive
            }
        case .siteManager:
            if task?.status == "0" {
                rightButton.isHidden = true
                leftButton.isHidden = false
                leftButton.setTitle("确认任务", for: .normal)
                leftButtonSelType = .confirmTask
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
            
            Service.shared.acceptTask(dispatchId: task.id, dispatchStartTime: dispatchStartTime, userId: userId, vehicleId: vehicleId).done { [weak self] result in
                switch result {
                case .success(_):
                    UIApplication.shared.keyWindow?.makeToast("已接受任务")
                    self?.navigationController?.popViewController(animated: true)
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
            Service.shared.refuseTask(dispatchId: task.id, userId: userId, reason: reason).done{ [weak self] result in
                switch result {
                case .success(_):
                    self?.view.makeToast("已拒绝任务")
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
        Service.shared.arrive(req: ArriveUpRequest.init(dispatchId: task.id, userId: uid, lng: lng, lat: lat)).done { [weak self] result in
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
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if let pinview = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")  {
            pinview.image = UIImage.init(named: "qidian")
            return pinview
        } else {
            if let pinview = MAAnnotationView.init(annotation: annotation, reuseIdentifier:"pin") {
                pinview.image = UIImage.init(named: "qidian")
                return pinview
            } else {
                return MAAnnotationView()
            }
        }

    }
}
