import UIKit
import DatePickerDialog
import Toast_Swift
class ViolationDetailViewController: BaseViewController {
    
    enum CellType {
        case plateNum
        case driver
        case violationType
        case price
        case violationTime
        case manager
        case image
        case rejectReason
        
        static func types(violation: ListViolationElement?, isEditable: Bool) -> [CellType] {
            var types = [CellType]()
            if isEditable {
                types = [
                    .plateNum,
                    .violationType,
                    .price,
                    .violationTime,
                    .manager,
                    .image
                ]
            } else {
                types = [
                    .plateNum,
                    .driver,
                    .violationType,
                    .price,
                    .violationTime,
                    .manager,
                    .image,
                ]
            }
            if violation?.rejectReason != nil {
                types.append(.rejectReason)
            }
            return types
        }
        
        func title() -> String {
            switch self {
            case .plateNum:
                return "车辆信息"
            case .driver:
                return "司机"
            case .violationType:
                return "违章类型"
            case .price:
                return "违章金额"
            case .violationTime:
                return "违章时间"
            case .manager:
                return "装点管理员"
            case .image:
                return "上传图片"
            case .rejectReason:
                return "驳回原因"
            }
        }
        
        func placeholder() -> String {
            switch self {
            case .plateNum:
                return "请选择" + title()
            case .driver:
                return "请选择" + title()
            case .violationType:
                return "请选择" + title()
            case .price:
                return "请输入" + title()
            case .violationTime:
                return "请选择" + title()
            case .manager:
                return "请选择" + title()
            case .image:
                return "请至少上传一张图片"
            case .rejectReason:
                return "请输入" + title()
            }
        }
        
    }
    
    var violation = ListViolationElement.init(companyId: nil, companyName: nil, createBy: nil, createTime: nil, creatorName: nil, id: nil, imageList: [ImageListElement](), isPayment: nil, peccancyPrice: nil, peccancyTime: nil, peccancyType: nil, peccancyTypeName: nil, peopleId: nil, peopleName: nil, plateNum: nil, rejectReason: nil, status: nil, updateBy: nil, updateTime: nil, updaterName: nil, userId: nil, userName: nil, vehicleId: nil, vehicleName: nil)
    var isEditable = false
    let tableView = UITableView(frame: .zero)
    let stackView = UIStackView()
    var cellTypes = [CellType]()
    
    var vioTypes: [DictElement]?
    var selectedVioType: DictElement?
    var vehicles: [LoginVehicleListElement]?
    var siteManagers: ListPeopleResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = isEditable ? "上报违章" : "违章"
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
        tableView.register(UINib.init(nibName: "FormSelectTableViewCell", bundle: .main), forCellReuseIdentifier: "FormSelectTableViewCell")
        tableView.register(UINib.init(nibName: "FormInputTableViewCell", bundle: .main), forCellReuseIdentifier: "FormInputTableViewCell")
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
        cellTypes = CellType.types(violation: violation, isEditable: isEditable)
        tableView.reloadData()
        reloadButtons()
        requestVioTypes()
        requestVehicles()
        requestSiteManager()
    }
    
    
    func requestSiteManager() {
        guard let cid = LoginManager.shared.user?.company.companyId else {
            return
        }
        Service.shared.listPeople(ListPeopleRequest.init(companyId: cid)).done{ [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.siteManagers = data
            default: break
            }
        }.cauterize()
    }
    
    func requestVioTypes() {
        Service.shared.listDictType(req: DictTypeRequest.init(dictType: .peccancy_type)).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.vioTypes = data
            default: break
            }
        }.cauterize()
    }
    
    func requestVehicles() {
        guard let cid = LoginManager.shared.user?.company.companyId,
              let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        Service.shared.listVehicles(companyId: cid, userId: uid).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.vehicles = data
                self?.tableView.reloadData()
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }.catch({[weak self] err in
            self?.view.makeToast(err.localizedDescription)
        })
    }
    
    func reloadButtons() {
        stackView.removeAllArrangedSubviews()
        for (_, element) in stackView.subviews.enumerated() {
            element.removeFromSuperview()
        }
        guard let post = LoginManager.shared.user?.post.postType else {
            stackView.snp.remakeConstraints({ make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(0)
            })
            return
        }
        if isEditable && violation.status == nil {
            stackView.addArrangedSubview(button(true))
            return
        }
        switch violation.status {
        case "0" where post == .siteManager:
            stackView.addArrangedSubview(button(true))
            stackView.addArrangedSubview(button(false))
        case "2", "3":
            stackView.addArrangedSubview(button(true))
        default:
            break
        }
    }
    
    func button(_ isConfirm: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(isEditable ? "上报违章" : (isConfirm ? "确认审批" : "驳回审批"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = isConfirm ? .confirmColor : .refuseColor
        button.cornerRadius = 7
        button.snp.makeConstraints({ make in
            make.height.equalTo(40)
        })
        button.addTarget(self, action: isConfirm ? #selector(confirmButton) : #selector(reject), for: .touchUpInside)
        return button
    }
    
    @objc
    func confirmButton() {
        showAlertWithConfirmClosure({ [weak self] in
            self?.confirm()
        }, title: "是否确认审批")
    }
    
    
    func confirm() {
        if !isEditable,
           let vid = violation.id {
            Service.shared.confirmViolation(ConfirmViolationRequest(peccancyId: vid)).done { [weak self] result in
                switch result {
                case .success(let res):
                    UIApplication.shared.keyWindow?.makeToast(res.msg ?? "操作成功")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let err):
                    UIApplication.shared.keyWindow?.makeToast(err.msg ?? "操作失败")
                }
              }.cauterize()
            return
        }
        guard let vid = violation.vehicleId else {
            view.makeToast(CellType.placeholder(.plateNum)())
            return
        }
        guard let vioType = violation.peccancyType else {
            view.makeToast(CellType.placeholder(.violationType)())
            return
        }
        guard let price = violation.peccancyPrice else {
            view.makeToast(CellType.placeholder(.price)())
            return
        }
        guard let time = violation.peccancyTime else {
            view.makeToast(CellType.placeholder(.violationTime)())
            return
        }
        guard let peopleId = violation.peopleId else {
            view.makeToast(CellType.placeholder(.manager)())
            return
        }
        
        guard let imgList = violation.imageList,
              imgList.count > 0 else {
            view.makeToast(CellType.placeholder(.image)())
            return
        }
        guard let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        
        if let vioId = violation.id {
            Service.shared.updateViolation(req: InserViolationRequest(imageList: imgList,
                                                                      peccancyTime: time,
                                                                      peccancyType: vioType,
                                                                      peopleId: peopleId,
                                                                      price: price,
                                                                      userId: uid,
                                                                      vehicleId: vid,
                                                                      peccancyId: vioId)).done { [weak self] result in
                                                                        switch result {
                                                                        case .success(let res):
                                                                            UIApplication.shared.keyWindow?.makeToast(res.msg ?? "操作成功")
                                                                            self?.navigationController?.popViewController(animated: true)
                                                                        case .failure(let err):
                                                                            UIApplication.shared.keyWindow?.makeToast(err.msg ?? "操作失败")
                                                                        }
                                                                      }.cauterize()
        } else {
            Service.shared.insertViolation(InserViolationRequest(imageList: imgList,
                                                                      peccancyTime: time,
                                                                      peccancyType: vioType,
                                                                      peopleId: peopleId,
                                                                      price: price,
                                                                      userId: uid,
                                                                      vehicleId: vid,
                                                                      peccancyId: nil)).done { [weak self] result in
                                                                        switch result {
                                                                        case .success(let res):
                                                                            UIApplication.shared.keyWindow?.makeToast(res.msg ?? "操作成功")
                                                                            self?.navigationController?.popViewController(animated: true)
                                                                        case .failure(let err):
                                                                            UIApplication.shared.keyWindow?.makeToast(err.msg ?? "操作失败")
                                                                        }
                                                                      }.cauterize()
        }
        
    }
    
    @objc
    func reject() {
        showInputAlert(confirmClosure: { [weak self] string in
            guard let str = string else {
                self?.view.makeToast("请输入驳回理由")
                return
            }
            self?.refuseRequest(reason: str)
        }, title: "驳回理由", placeholder: "请输入驳回理由")
    }
    
    func refuseRequest(reason: String) {
        guard let vid = violation.id else {
            return
        }
        Service.shared.refuseViolation(req: ViolationRefuseRequest(rejectReason: reason, peccancyId: vid)).done { [weak self] result in
            switch result {
            case .success(let resp):
                UIApplication.shared.keyWindow?.makeToast(resp.msg ?? "操作成功")
                self?.navigationController?.popViewController(animated: true)
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch { error in
            UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
        }
    }
    
}

extension ViolationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch type {
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.configEditable(self.isEditable)
            cell.delegate = self
            if self.isEditable {
                cell.configAlbums(violation.imageList?.compactMap{ UploadFileResponse.init(msg: nil, code: nil, fileName: $0.name, url: $0.url) } ?? [])
            } else {
                cell.imageElements = violation.imageList
            }
            
            return cell
        case .rejectReason:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextViewTableViewCell") as? FormTextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textView.isEditable = false
            cell.textView.text = violation.rejectReason
            return cell
        case .plateNum where isEditable == true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titles = vehicles?.compactMap{ $0.plateNum }
            cell.titleLabel.text = type.title()
            cell.defaultInfoText = type.placeholder()
            cell.defaultAlertText = "没有可选的" + type.title()
            if let text = violation.plateNum {
                cell.infoLabel.text = text
                cell.infoLabel.textColor = .black
            } else {
                cell.infoLabel.text = cell.defaultInfoText
                cell.infoLabel.textColor = .lightGray
            }
            return cell
        case .violationType where isEditable == true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titles = vioTypes?.compactMap{ $0.dictLabel }
            cell.titleLabel.text = type.title()
            cell.defaultInfoText = type.placeholder()
            cell.defaultAlertText = "没有可选的" + type.title()
            if let text = violation.peccancyTypeName {
                cell.infoLabel.text = text
                cell.infoLabel.textColor = .black
            } else {
                cell.infoLabel.text = cell.defaultInfoText
                cell.infoLabel.textColor = .lightGray
            }
            return cell
        case .manager where isEditable == true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titles = siteManagers?.compactMap{ $0.peopleNickName }
            cell.titleLabel.text = type.title()
            cell.defaultInfoText = type.placeholder()
            cell.defaultAlertText = "没有可选的" + type.title()
            if let text = violation.peopleName {
                cell.infoLabel.text = text
                cell.infoLabel.textColor = .black
            } else {
                cell.infoLabel.text = cell.defaultInfoText
                cell.infoLabel.textColor = .lightGray
            }
            return cell
        case .price where isEditable == true:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textField.placeholder = type.placeholder()
            cell.textField.keyboardType = .numbersAndPunctuation
            cell.textField.setInputAccessoryView()
            cell.delegate = self
            if let p = violation.peccancyPrice {
                cell.textField.text = String.init(format: "%.2f",  p)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            switch type {
            case .plateNum:
                cell.infoLabel.text = violation.plateNum
            case .driver:
                cell.infoLabel.text = violation.creatorName
            case .violationType:
                cell.infoLabel.text = violation.peccancyTypeName
            case .price:
                cell.infoLabel.text = String(format: "%.2f", violation.peccancyPrice ?? 0)
            case .violationTime:
                if let text = violation.peccancyTime {
                    cell.infoLabel.text = text
                }
            case .manager:
                cell.infoLabel.text = violation.peopleName
            default: break
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = cellTypes[safe: indexPath.row],
              isEditable == true else {
            return
        }
        switch type {
        case .violationTime:
            let dialog = DatePickerDialog(locale: Locale.init(identifier: "zh_CN"))
            
            dialog.show("开始时间",
                        doneButtonTitle: "确定",
                        cancelButtonTitle: "取消",
                        defaultDate: Date.now,
                        maximumDate: Date.now,
                        datePickerMode: .dateAndTime) { [weak self] date in
                guard let date = date else {
                    return
                }
                self?.violation.peccancyTime = date.toString(format: .debug, locale: "zh_CN")
                self?.tableView.reloadData()
            }
            dialog.datePicker.snp.makeConstraints{ make in
                make.width.equalToSuperview()
                make.height.equalTo(281)
                make.centerX.centerY.equalToSuperview()
            }
        default:
            break
        }
    }
    
}
extension ViolationDetailViewController: FormSelectDelegate, FormInputProtocol {
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell),
              let type = cellTypes[safe: indexpath.row] else {
            return
        }
        switch type {
        case .plateNum:
            guard let vehicle = vehicles?[safe: indexPath.row] else {
                return
            }
            violation.vehicleId = vehicle.id
            violation.vehicleName = vehicle.vehicleName
            violation.plateNum = vehicle.plateNum
        case .violationType:
            guard let violationType = vioTypes?[safe: indexPath.row] else {
                return
            }
            violation.peccancyType = violationType.dictValue
            violation.peccancyTypeName = violationType.dictLabel
        case .manager:
            guard let manager = siteManagers?[safe: indexPath.row] else {
                return
            }
            violation.peopleId = manager.peopleId
            violation.peopleName = manager.peopleNickName
        
        default:
            break
        }
        tableView.reloadData()
    }
    
    func textDidChange(cell: FormInputTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell),
              let type = cellTypes[safe: indexpath.row] else {
            return
        }
        switch type {
        case .price:
            guard let priceStr = cell.textField.text,
                  let price = Double(priceStr) else {
                return
            }
            violation.peccancyPrice = price
        default: break
        }
    }
}

extension ViolationDetailViewController: ChangeProfileAlbumTableViewCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func deleteAlbumPhoto(_ indexpath: Int) {
        violation.imageList?.remove(at: indexpath)
        tableView.reloadData()
    }
    
    func addAlbumPhoto() {
        let imagePicker = UIImagePickerController.init()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: {})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        view.makeToastActivity(ToastPosition.center)
        UploadTool.uploadImage(image: image).done { [weak self] result in
            self?.violation.imageList?.append(ImageListElement.init(name: result.fileName, url: result.url))
            self?.tableView.reloadData()
            self?.view.hideToastActivity()
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
}
