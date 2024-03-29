import UIKit
import Toast_Swift
import DatePickerDialog

class ApplyRepairViewController: BaseViewController {
    enum CellType {
        case plateNum
        case repairPrice
        case repairType
        case startTime
        case endTime
        case image
        case rejectReason

        static func types() -> [CellType] {
            return [
                .plateNum,
                .repairPrice,
                .repairType,
                .startTime,
                .endTime,
                .image
            ]
        }
        
        func title() -> String {
            switch self {
            case .plateNum:
                return "车辆信息:"
            case .repairPrice:
                return "维修价格:"
            case .repairType:
                return "维修类型:"
            case .startTime:
                return "开始日期:"
            case .endTime:
                return "结束如期:"
            case .image:
                return "照片:"
            case .rejectReason:
                return "驳回理由"
            }
        }
        
        func placeholder() -> String {
            switch self {
            case .plateNum:
                return "请选择车辆信息"
            case .repairPrice:
                return "请选择维修价格"
            case .repairType:
                return "请选择维修类型"
            case .startTime:
                return "请选择开始日期"
            case .endTime:
                return "请选择结束如期"
            case .image:
                return ""
            case .rejectReason:
                return ""
            }
        }
        
        
    }
    
    let tableView = UITableView()
    var cellTypes = CellType.types()
    let footerButton = UIButton()
    var repairModel: ListRepairElement?
    
    var vehicles: [LoginVehicleListElement]?
    var selectedVehicle: LoginVehicleListElement?
    var startDate: Date?
    var endDate: Date?
    var imageUploadResponses = [UploadFileResponse]()
    
    var repairTypes: [DictElement]?
    var selectedRepairType: DictElement?
    
    var price: Double?
    
    var model: ListRepairElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "维修"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
//        tableView.separatorStyle = .none
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        tableView.register(UINib.init(nibName: "FormSelectTableViewCell", bundle: .main), forCellReuseIdentifier: "FormSelectTableViewCell")
        tableView.register(UINib.init(nibName: "FormInputTableViewCell", bundle: .main), forCellReuseIdentifier: "FormInputTableViewCell")
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(UINib.init(nibName: "FormTextViewTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTextViewTableViewCell")
        
        view.addSubview(footerButton)
        footerButton.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        footerButton.backgroundColor = .systemBlue
        footerButton.setTitleColor(.white, for: .normal)
        footerButton.setTitle("上报维修", for: .normal)
        footerButton.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
        footerButton.cornerRadius = 5
        requestVehicles()
        listDictType()
    }
    
    func configWithRepairModel(_ model: ListRepairElement) {
        self.model = model
        selectedVehicle = LoginVehicleListElement.init(companyId: model.companyId,
                                                       createTime: "",
                                                       driveNum: "",
                                                       frameNum: "",
                                                       id: model.vehicleId,
                                                       plateNum: model.plateNum,
                                                       tonnage: "",
                                                       vehicleBrand: "",
                                                       vehicleName: model.vehicleName,
                                                       vehicleType: "")
        price = model.repairPrice
        selectedRepairType = DictElement.init(dictLabel: model.repairTypeName, dictValue: model.repairType)
        startDate = model.startTime?.toDate(format: .debug, locale: "zh_CN")
        endDate = model.endTime?.toDate(format: .debug, locale: "zh_CN")
        imageUploadResponses = model.imageList?.map{
            UploadFileResponse.init(msg: nil, code: nil, fileName: $0.name, url: $0.url)
        } ?? [UploadFileResponse]()
        if model.rejectReason != nil {
            cellTypes = CellType.types()
            cellTypes.append(.rejectReason)
        }
        tableView.reloadData()
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
    
    func listDictType() {
        Service.shared.listDictType(req: DictTypeRequest(dictType: .repair_type)).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.repairTypes = data
            default: break
            }
        }.cauterize()
    }
    
    @objc
    func buttonSelector() {
        guard let vid = selectedVehicle?.id else {
            view.makeToast("请选择车辆信息")
            return
        }
        guard let priceCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? FormInputTableViewCell,
              let price = priceCell.textField.text,
               let priceNum = Double(price) else {
            view.makeToast("请输入维修价格")
            return
        }
        guard let type = selectedRepairType,
              let typeValue = type.dictValue else {
            view.makeToast("请输入维修类型")
            return
        }
        guard let startDate = startDate else {
            view.makeToast("请选择开始日期")
            return
        }
        guard let endDate = endDate else {
            view.makeToast("请输入结束日期")
            return
        }
        guard let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        let imagelist: [ImageListElement] = imageUploadResponses.compactMap {
             ImageListElement(name: $0.fileName, url: $0.url)
        }
        let startDateStr = startDate.toString(format: .debug, locale: "zh_CN")
        let endDateStr = endDate.toString(format: .debug, locale: "zh_CN")
        
        showAlertWithConfirmClosure({ [weak self] in
            guard let self = self else { return }
            if let model = self.model {
                Service.shared.updateRepair(InsertRepairRequest.init(endTime: endDateStr,
                                                                     imageList: imagelist,
                                                                     price: priceNum,
                                                                     repairFlag: 1,
                                                                     repairType: typeValue,
                                                                     startTime: startDateStr,
                                                                     userId: uid,
                                                                     vehicleId: vid, id: model.id)).done { [weak self] result in
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
            } else {
                Service.shared.insertRepair(InsertRepairRequest.init(endTime: endDateStr,
                                                                     imageList: imagelist,
                                                                     price: priceNum,
                                                                     repairFlag: 1,
                                                                     repairType: typeValue,
                                                                     startTime: startDateStr,
                                                                     userId: uid,
                                                                     vehicleId: vid, id: nil)).done { [weak self] result in
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
            }
            
        }, title: "确定上报维修？")
        
    }
    
}

extension ApplyRepairViewController: UITableViewDelegate, UITableViewDataSource, ChangeProfileAlbumTableViewCellProtocol, FormSelectDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch type {
        case .plateNum, .repairType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titleLabel.text = type.title()
            cell.defaultInfoText = type.placeholder()
            cell.defaultAlertText = "没有可选的" + type.title()
            
            if type == .plateNum {
                if let selectedVehicle = selectedVehicle {
                    cell.presetValue(selectedVehicle.plateNum ?? "")
                }
                cell.titles = vehicles?.compactMap{
                    $0.plateNum
                }
            } else if type == .repairType {
                if let repType = selectedRepairType {
                    cell.presetValue(repType.dictLabel ?? "")
                }
                cell.titles = repairTypes?.compactMap{
                    $0.dictLabel
                }
            }
            
            return cell
        case .repairPrice:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textField.placeholder = type.placeholder()
            cell.delegate = self
            if type == .repairPrice {
                cell.textField.keyboardType = .numbersAndPunctuation
            }
            cell.textField.setInputAccessoryView()
            if let price = self.price {
                cell.textField.text = String.init(format: "%.2f", price)
            }
            return cell
        case .startTime, .endTime:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            if type == .startTime,
               let startTime = startDate?.toString(format: .debug2, locale: "zh_CN") {
                cell.infoLabel.text = startTime
            } else if type == .endTime,
                      let endTime = endDate?.toString(format: .debug2, locale: "zh_CN") {
                cell.infoLabel.text = endTime
            }
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configAlbums(imageUploadResponses)
            return cell
        case .rejectReason:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextViewTableViewCell") as? FormTextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textView.isEditable = false
            cell.textView.text = model?.rejectReason
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 3:
            let dialog = DatePickerDialog(locale: Locale.init(identifier: "zh_CN"))
            dialog.show("开始时间",
                        doneButtonTitle: "确定",
                        cancelButtonTitle: "取消",
                        defaultDate: startDate ?? Date.now.weekBefore,
                        maximumDate: endDate,
                        datePickerMode: .date) { [weak self] date in
                guard let date = date else {
                    return
                }
                self?.startDate = date
                self?.tableView.reloadData()
            }
        case 4:
            let dialog = DatePickerDialog(locale: Locale.init(identifier: "zh_CN"))
            dialog.show("结束时间",
                        doneButtonTitle: "确定",
                        cancelButtonTitle: "取消",
                        defaultDate: endDate ?? Date.now,
                        minimumDate: startDate,
                        datePickerMode: .date) { [weak self] date in
                guard let date = date else {
                    return
                }
                self?.endDate = date
                self?.tableView.reloadData()
            }
        default: break
        }
    }
    
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell) {
        guard let cellIndexPath = tableView.indexPath(for: cell) else {
            return
        }
        switch cellIndexPath.row {
        case 0:
            selectedVehicle = vehicles?[safe: indexPath.row]
            tableView.reloadData()
        case 2:
            selectedRepairType = repairTypes?[safe: indexPath.row]
            tableView.reloadData()
        default: break
        }
    }
    
    func deleteAlbumPhoto(_ indexpath: Int) {
        imageUploadResponses.remove(at: indexpath)
        tableView.reloadData()
    }
    
    func addAlbumPhoto() {
        let imagePicker = UIImagePickerController.init()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: {})
    }
    
}

extension ApplyRepairViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, FormInputProtocol {
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
            self?.imageUploadResponses.append(result)
            self?.tableView.reloadData()
            self?.view.hideToastActivity()
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
    
    func textDidChange(cell: FormInputTableViewCell) {
        guard let text = cell.textField.text,
              let price = Double(text) else {
            return
        }
        self.price = price
    }
    
}
