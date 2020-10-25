import UIKit
import Toast_Swift
class ApplyGasViewController: BaseViewController {
    
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
    var vehicles: [LoginVehicleListElement]?
    var selectedVehicle: LoginVehicleListElement?
    var driverList: [DriverListElement]?
    var selectedDriver: DriverListElement?
    var imageUploadResponses = [UploadFileResponse]()
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
        requestVehicles()
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
        guard let vid = selectedVehicle?.id else {
            view.makeToast("请选择车辆")
            return
        }
        guard let driverId = selectedDriver?.userId else {
            view.makeToast("请选择司机")
            return
        }
        guard let pricecell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as? FormInputTableViewCell,
              let price = pricecell.textField.text,
              let pricenum = Double(price) else {
            view.makeToast("请输入单价")
            return
        }
        guard let gascell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as? FormInputTableViewCell,
              let gas = gascell.textField.text,
              let gasNum = Double(gas) else {
            view.makeToast("请输入加油量")
            return
        }
        
        guard let totalCell = tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as? FormInputTableViewCell,
              let total = totalCell.textField.text,
              let totalNum = Double(total) else {
            view.makeToast("请输入总价")
            return
        }
        let imagelist: [ImageListElement] = imageUploadResponses.compactMap {
             ImageListElement(name: $0.fileName, url: $0.url)
        }
        
        guard let cid = LoginManager.shared.user?.company.companyId,
              let createBy = LoginManager.shared.user?.user.userId  else {
            return
        }
        Service.shared.insertOilOut(InsertOilOutRequest.init(companyId: cid,
                                                             createBy: createBy,
                                                             driverId: driverId,
                                                             imageList: imagelist,
                                                             oilPrice: pricenum,
                                                             oilTonnage: gasNum,
                                                             oilType: "",
                                                             total: totalNum,
                                                             vehicleId: vid)).done { [weak self] result in
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
extension ApplyGasViewController: UITableViewDelegate, UITableViewDataSource, FormSelectDelegate, ChangeProfileAlbumTableViewCellProtocol {
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
            if type == .carInfo {
                if let selectedVehicle = selectedVehicle {
                    cell.infoLabel.text = selectedVehicle.plateNum
                }
                cell.titles = vehicles?.compactMap{
                    $0.plateNum
                }
            } else if type == .driverInfo {
                if let driver = selectedDriver {
                    cell.infoLabel.text = driver.nickName
                }
                cell.titles = driverList?.compactMap{
                    $0.nickName
                }
            }
            cell.delegate = self
            return cell
        case .price, .gasAmount, .total:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title() + ":"
            cell.textField.placeholder = type.placeHolder()
            cell.textField.keyboardType = .numbersAndPunctuation
            cell.textField.setInputAccessoryView()
            return cell
        case .uploadImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configAlbums(imageUploadResponses)
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
            tableView.reloadData()
            requestDrivers()
        case 1:
            selectedDriver = driverList?[safe: indexPath.row]
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

extension ApplyGasViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
