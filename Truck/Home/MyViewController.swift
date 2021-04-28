import UIKit

class MyViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum MyInfoType {
        case account(_ account: String)
        case name(_ name: String)
        case position(_ position: String)
        case companyName(_ companyName: String)
        case telephone(_ telephone: String)
        case numberPlate(_ numer: String)
        case vehicleBrand(_ brand: String)
        func title() -> String {
            switch self {
            case .account:
                return "账号"
            case .name:
                return "姓名"
            case .position:
                return "职位"
            case .companyName:
                return "公司名称"
            case .telephone:
                return "公司电话"
            case .vehicleBrand:
                return "车品牌"
            case .numberPlate:
                return "车牌号"
            }
        }
        
    }
    struct LayoutSection {
        let title: String
        let rows: [MyInfoType]
    }
    
    var tableView: UITableView!
    
    func layoutTypes() -> [LayoutSection] {
        guard let response = LoginManager.shared.user else {
            return []
        }
        let layoutTypes = [
            LayoutSection.init(title: "个人信息", rows: [
                .account(response.user.phonenumber ?? ""),
                .name(response.user.nickName ?? ""),
                .position(response.post.postName ?? ""),
            ]),
            LayoutSection.init(title: "车辆信息", rows: [
                .numberPlate(response.vehicle?.count == 0 ? "" : (response.vehicle![0].plateNum ?? "")),
                .vehicleBrand(response.vehicle?.count == 0 ? "" : (response.vehicle![0].vehicleBrand ?? ""))
            ]),
            LayoutSection.init(title: "公司信息", rows: [
                .companyName(response.company.alias ?? ""),
                .telephone(response.company.telephone ?? "")
            ])
        ]
        return layoutTypes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人中心"
        tableView = UITableView.init(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TitleInfoLabelTableViewCell", bundle: .main), forCellReuseIdentifier: "TitleInfoLabelTableViewCell")
        tableView.register(TitledHeaderView.self, forHeaderFooterViewReuseIdentifier: "TitledHeaderView")
        tableView.register(ButtonFooterView.self, forHeaderFooterViewReuseIdentifier: "ButtonFooterView")
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    func routeToRevise() {
        navigationController?.pushViewController(RevisePWViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleInfoLabelTableViewCell") as? TitleInfoLabelTableViewCell else {
            return UITableViewCell()
        }
        
        let infoType = layoutTypes()[indexPath.section].rows[indexPath.row]
        cell.titleLabel.text = infoType.title()
        switch infoType {
        case .account(let account):
            cell.infoLabel.text = account
        case .name(let name):
            cell.infoLabel.text = name
        case .position(let position):
            cell.infoLabel.text = position
        case .companyName(let companyName):
            cell.infoLabel.text = companyName
        case .telephone(let telephone):
            cell.infoLabel.text = telephone
        case .numberPlate(let plate):
            cell.infoLabel.text = plate
        case .vehicleBrand(let brand):
            cell.infoLabel.text = brand
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return layoutTypes()[section].rows.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return layoutTypes().count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitledHeaderView") as? TitledHeaderView else {
            return UIView()
        }
        header.titleLabel.text = layoutTypes()[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else {
            return nil
        }
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ButtonFooterView") as? ButtonFooterView else {
            return nil
        }
        footer.button.setTitle("退出登陆", for: .normal)
        footer.closure = {
            LoginManager.shared.logout()
        }
        footer.revise = { [weak self] in
            //TODO:
            self?.routeToRevise()
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard section == 2 else {
            return 0
        }
        return 110
    }
    
}
