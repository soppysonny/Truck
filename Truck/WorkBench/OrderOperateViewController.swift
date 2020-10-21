import UIKit
import Toast_Swift

class OrderOperateViewController: BaseViewController {
    var type: OrderDetailBottomButtonType = .applyForTransfer
    let tableView = UITableView()
    let footerButton = UIButton()
    var rowTypes = [OrderDetailRowType]()
    var orderDetail: OrderDetailResponse? = nil
    var addressList: [ListAddressResponse]?
    
    var selectedAddr: ListAddressResponse?
    var imageUploadResponses = [UploadFileResponse]()
    
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
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
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
        if (type == .siteManagerConfirm || type == .confirmTransfer) && selectedAddr == nil {
            view.makeToast("请选择地址")
            return
        }
        guard let orderId = orderDetail?.id else {
            return
        }
        let imagelist: [ImageListElement] = imageUploadResponses.compactMap {
             ImageListElement(name: $0.fileName, url: $0.url)
        }
        
        Service.shared.orderOperation(downId: selectedAddr?.id, imageList: imagelist, orderId: orderId, type: type.rawValue).done { [weak self] result in
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
        return rowTypes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= rowTypes.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.configAlbums(imageUploadResponses)
            return cell
        }
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
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell) {
        guard let addrList = addressList,
              let addr = addrList[safe: indexPath.row] else {
            return
        }
        selectedAddr = addr
    }
}

extension OrderOperateViewController: ChangeProfileAlbumTableViewCellProtocol {
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

extension OrderOperateViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
