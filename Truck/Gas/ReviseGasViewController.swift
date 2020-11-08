import Toast_Swift
class ReviseGasViewController: BaseViewController {
    
    enum CellType: Equatable {
        case carInfo
        case driverInfo
        case oilType
        case price
        case gasAmount
        case total
        case uploadImage
        case rejectReason(reason: String?)
        
        static func types(gasRecord: GetOilOutByCreateByElement) -> [CellType] {
            var types: [CellType] = [
                .carInfo,
                .driverInfo,
                .oilType,
                .price,
                .gasAmount,
                .total,
                .uploadImage
            ]
            if gasRecord.rejectReason != nil {
                types.append(.rejectReason(reason: gasRecord.rejectReason))
            }
            return types
        }
        
        func title() -> String {
            switch self {
            case .carInfo:
                return "车辆信息"
            case .driverInfo:
                return "司机信息"
            case .oilType:
                return "加油类型"
            case .price:
                return "单价"
            case .gasAmount:
                return "加油量"
            case .total:
                return "总价"
            case .uploadImage:
                return "上传图片"
            case .rejectReason:
                return " 驳回理由"
            }
        }

        func placeHolder() -> String {
            switch self {
            case .carInfo:
                return "请选择" + title()
            case .driverInfo:
                return "请选择" + title()
            case .oilType:
                return "请选择" + title()
            case .price:
                return "请输入" + title() + "（元）"
            case .gasAmount:
                return "请输入" + title()
            case .total:
                return "请输入" + title() + "（元）"
            case .uploadImage:
                return "上传图片"
            case .rejectReason:
                return ""
            }
        }
        
    }
    
    let tableView = UITableView()
    var cellTypes = [CellType]()
    let footerButton = UIButton()
    var vehicles: [LoginVehicleListElement]? {
        didSet {
            if let vehicle = vehicles?.first(where: { $0.id == gasRecord?.vehicleId }) {
                selectedVehicle = vehicle
            }
            tableView.reloadData()
        }
    }
    var selectedVehicle: LoginVehicleListElement? {
        didSet {
            guard let vehicle = selectedVehicle else {
                return
            }
            requestDrivers()
            gasRecord?.vehicleId = vehicle.id
        }
    }
    var driverList: [DriverListElement]? {
        didSet {
            if let driver = driverList?.first(where: { $0.userId == gasRecord?.driverId }) {
                selectedDriver = driver
            }
            tableView.reloadData()
        }
    }
    var selectedDriver: DriverListElement? {
        didSet {
            guard let driver = selectedDriver else {
                return
            }
            gasRecord?.driverId = driver.userId
            gasRecord?.driverName = driver.nickName
        }
    }
    var imageUploadResponses = [UploadFileResponse]()
    var oilTypes: [DictElement]?
    var selectedOilType: DictElement?
    
    var gasRecord: GetOilOutByCreateByElement? {
        didSet {
            guard let gasRecord = gasRecord else {
                return
            }
            selectedOilType = DictElement.init(dictLabel: gasRecord.oilTypeName, dictValue: gasRecord.oilType)
            if let imageList = gasRecord.imageList {
                imageUploadResponses = imageList.map{
                    UploadFileResponse.init(msg: nil, code: nil, fileName: $0.name, url: $0.url)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "上报加油"
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
        footerButton.setTitle("确认提交", for: .normal)
        footerButton.addTarget(self, action: #selector(buttonSelector), for: .touchUpInside)
        footerButton.cornerRadius = 5
        if let r = gasRecord {
            cellTypes = CellType.types(gasRecord: r)
            tableView.reloadData()
        }
        requestVehicles()
        requestOilTypes()
    }
    
    func requestOilTypes() {
        Service.shared.listDictType(req: DictTypeRequest.init(dictType: .oil_type)).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.oilTypes = data
            default: break
            }
        }.cauterize()
    }
        func requestVehicles() {
        guard let cid = LoginManager.shared.user?.company.companyId else {
            return
        }
        Service.shared.listVehicles(companyId: cid, userId: "").done { [weak self] result in
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
    
    func requestDrivers() {
        guard let vehicle = selectedVehicle else {
            return
        }
        Service.shared.listDriver(vehicleId: vehicle.id).done{ [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.driverList = data
                self?.tableView.reloadData()
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
    
    @objc
    func buttonSelector() {
        guard let gasRecord = gasRecord,
              let recordId = gasRecord.id else {
            return
        }
        guard let vid = gasRecord.vehicleId else {
            view.makeToast("请选择车辆")
            return
        }
        
        guard let driverId = gasRecord.driverId else {
            view.makeToast("请选择司机")
            return
        }
        guard let pricenum = gasRecord.oilPrice else {
            view.makeToast("请输入单价")
            return
        }
        guard let oilType = selectedOilType?.dictValue else {
            view.makeToast("请选择加油类型")
            return
        }
        guard let gasNum = gasRecord.oilTonnage else {
            view.makeToast("请输入加油量")
            return
        }
        
        guard let totalNum = gasRecord.total else {
            view.makeToast("请输入总价")
            return
        }
        let imagelist: [ImageListElement] = imageUploadResponses.compactMap {
             ImageListElement(name: $0.fileName, url: $0.url)
        }
        guard imagelist.count > 0 else {
            view.makeToast("请至少上传一张图片")
            return
        }
        
        guard let createBy = LoginManager.shared.user?.user.userId  else {
            return
        }
        
        Service.shared.updateOilOutById(UpdateOilOutByIdRequest(driverId: driverId,
                                                                id: recordId,
                                                                imageList: imagelist,
                                                                oilPrice: pricenum,
                                                                oilTonnage: gasNum,
                                                                oilType: oilType,
                                                                total: totalNum,
                                                                updateBy: createBy, vehicleId: vid)).done { [weak self] result in
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
}
extension ReviseGasViewController: UITableViewDelegate, UITableViewDataSource, FormSelectDelegate, ChangeProfileAlbumTableViewCellProtocol, FormInputProtocol {
    func textDidChange(cell: FormInputTableViewCell) {
        guard let indexpath = tableView.indexPath(for: cell),
              let type = cellTypes[safe: indexpath.row] else {
            return
        }
        switch type {
        case .price:
            if let priceStr = cell.textField.text,
               let price = Double(priceStr) {
                gasRecord?.oilPrice = price
            }
        case .gasAmount:
            if let gasAmountStr = cell.textField.text,
               let gasAmount = Double(gasAmountStr) {
                gasRecord?.oilTonnage = gasAmount
            }
        case .total:
            if let totalStr = cell.textField.text,
               let totalNum = Double(totalStr) {
                gasRecord?.total = totalNum
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch type {
        case .carInfo, .driverInfo, .oilType:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title() + ":"
            cell.defaultInfoText = type.placeHolder()
            cell.defaultAlertText = "没有可选的" + type.title()
            if type == .carInfo {
                if let selectedVehicle = selectedVehicle {
                    cell.infoLabel.text = selectedVehicle.plateNum
                    cell.infoLabel.textColor = .black
                }
                cell.titles = vehicles?.compactMap{
                    $0.plateNum
                }
            } else if type == .driverInfo {
                if let driver = selectedDriver {
                    cell.infoLabel.text = driver.nickName
                    cell.infoLabel.textColor = .black
                }
                cell.titles = driverList?.compactMap{
                    $0.nickName
                }
            } else if type == .oilType {
                if let oilType = selectedOilType {
                    cell.infoLabel.text = oilType.dictValue
                    cell.infoLabel.textColor = .black
                }
                cell.titles = oilTypes?.compactMap{ $0.dictLabel }
            }
            cell.delegate = self
            return cell
        case .price, .gasAmount, .total:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.titleLabel.text = type.title() + ":"
            cell.textField.placeholder = type.placeHolder()
            cell.textField.keyboardType = .numbersAndPunctuation
            cell.textField.setInputAccessoryView()
            switch type {
            case .price:
                cell.textField.text = String.init(format: "%.2f", gasRecord?.oilPrice ?? 0)
            case .gasAmount:
                cell.textField.text = String.init(format: "%.2f", gasRecord?.oilTonnage ?? 0)
            case .total:
                cell.textField.text = String.init(format: "%.2f", gasRecord?.total ?? 0)
            default:
                break
            }
            return cell
        case .uploadImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configAlbums(imageUploadResponses)
            return cell
        case .rejectReason(let reason):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextViewTableViewCell") as? FormTextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textView.text = reason
            cell.textView.isEditable = false
            return cell
        }
    }
    
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell) {
        guard let cellIndexPath = tableView.indexPath(for: cell) else {
            return
        }
        switch cellIndexPath.row {
        case 0:
            selectedVehicle = vehicles?[safe: indexPath.row]
        case 1:
            selectedDriver = driverList?[safe: indexPath.row]
            tableView.reloadData()
        case 2:
            selectedOilType = oilTypes?[safe: indexPath.row]
            tableView.reloadData()
        default:
            return
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

extension ReviseGasViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
}
