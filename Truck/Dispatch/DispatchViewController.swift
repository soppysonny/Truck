import UIKit

class DispatchViewController: BaseViewController {
    let headerImageView = UIImageView()
    let tableview = UITableView()
    
    let button = UIButton()
    
    var addressList: [ListAddressResponse]?
    var projectList: [ProjectListElement]?
    var vehicleList: [LoginVehicleListElement]?
    
    var selectedAddress: ListAddressResponse?
    var selectedProject: ProjectListElement?
    var selectedVehicle: LoginVehicleListElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "临时调度"
        view.addSubview(headerImageView)
        let height = 1 / 2.4 * (UIScreen.main.bounds.width - 40)
        headerImageView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(height)
        })
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.image = #imageLiteral(resourceName: "banner")
        
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints({ make in
            make.top.equalTo(headerImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
        tableview.tableFooterView = UIView()
        tableview.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        tableview.register(UINib.init(nibName: "FormSelectTableViewCell", bundle: .main), forCellReuseIdentifier: "FormSelectTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        
        view.addSubview(button)
        button.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        button.setTitle("调度", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(dispatch), for: .touchUpInside)
        requestProjects()
        requestVehicle()
    }
    
    @objc
    func dispatch() {
        guard let cid = LoginManager.shared.user?.company.companyId else {
            view.makeToast("无公司信息")
            return
        }
        guard let uid = LoginManager.shared.user?.user.userId else {
            LoginManager.shared.logout()
            return
        }
        guard let pid = selectedProject?.projectId else {
            view.makeToast("请选择工程")
            return
        }
        guard let vehicleId = selectedVehicle?.id else {
            view.makeToast("请选择车辆")
            return
        }
        guard let addressId = selectedAddress?.id else {
            view.makeToast("请选择地址")
            return
        }
        Service.shared.dispatch(req: DispatchRequest.init(companyId: cid, projectId: pid, upAddressId: addressId, userId: uid, vehicleId: vehicleId)).done({ [weak self] result in
            switch result {
            case .success:
                UIApplication.shared.keyWindow?.makeToast("调度成功")
                self?.navigationController?.popViewController(animated: true)
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }).catch({ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    
    func requestProjects() {
        guard let cid = LoginManager.shared.user?.company.companyId,
              let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        Service.shared.listProject(companyId: cid, userId: uid).done({ [weak self] result in
            switch result {
            case .success(let resp):
                guard let list = resp.data else {
                    return
                }
                self?.projectList = list
                self?.tableview.reloadData()
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }).catch({ [weak self]error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    
    func requestLoadLocation(projectId: String) {
        guard let cid = LoginManager.shared.user?.company.companyId else {
            view.makeToast("companyId为空")
            return
        }
        Service.shared.listAddress(addressType: "1",
                                   companyId: cid,
                                   projectId: projectId,
                                   userId: LoginManager.shared.user?.user.userId).done { [weak self] result in
                                    switch result {
                                    case .success(let resp):
                                        guard let addressList = resp.data else {
                                            return
                                        }
                                        self?.addressList = addressList
                                        self?.tableview.reloadData()
                                    default: break
                                    }
                                   }.cauterize()
    }
    
    func requestVehicle() {
        guard let cid = LoginManager.shared.user?.company.companyId else {
            return
        }
        Service.shared.listVehicles(companyId: cid, userId: nil).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let list = resp.data else {
                    return
                }
                self?.vehicleList = list
                self?.tableview.reloadData()
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }.catch { [weak self] err in
            self?.view.makeToast(err.localizedDescription)
        }
    }

}

extension DispatchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "FormSelectTableViewCell") as? FormSelectTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "工程名称"
            cell.defaultInfoText = "请选择工程名称"
            cell.defaultAlertText = "没有可以选择的工程名称"
            cell.titles = projectList?.compactMap{
                $0.projectName
            }
            cell.infoLabel.text = selectedProject?.projectName ?? cell.defaultInfoText
            cell.delegate = self
        case 1:
            cell.titleLabel.text = "车辆信息"
            cell.defaultInfoText = "请选择车辆信息"
            cell.defaultAlertText = "没有可以选择的车辆信息"
            cell.titles = vehicleList?.compactMap{
                $0.plateNum
            }
            cell.infoLabel.text = selectedVehicle?.plateNum ?? cell.defaultInfoText
            cell.delegate = self
        case 2:
            cell.titleLabel.text = "装点"
            cell.defaultInfoText = "请选择装点"
            cell.defaultAlertText = "没有可以选择的装点"
            cell.titles = addressList?.compactMap{
                $0.addressName
            }
            cell.infoLabel.text = selectedAddress?.addressName ?? cell.defaultInfoText
            cell.delegate = self
        default: break
        }
        return cell
    }
    
}

extension DispatchViewController: FormSelectDelegate {
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell) {
        guard let cellIndexpath = tableview.indexPath(for: cell) else {
            return
        }
        switch cellIndexpath.row {
        case 0:
            selectedProject = projectList?[safe: indexPath.row]
            tableview.reloadData()
            guard let pid = selectedProject?.projectId else {
                return
            }
            requestLoadLocation(projectId: pid)
        case 1:
            selectedVehicle = vehicleList?[safe: indexPath.row]
            tableview.reloadData()
        case 2:
            selectedAddress = addressList?[safe: indexPath.row]
            tableview.reloadData()
        default: break
        }
    }
        
    
}
