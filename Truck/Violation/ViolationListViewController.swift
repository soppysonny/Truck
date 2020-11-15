import UIKit
import PullToRefresh
import PromiseKit

class ViolationListViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    var flag: Int = 1
    let tableView = UITableView()
    var rows = [ListViolationElement]()
    let topRefresher = PullToRefresh()
    let bottomLoader = PullToRefresh()
    var page = 1
    var total: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.layer.masksToBounds = false
        tableView.snp.makeConstraints{ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.register(UINib.init(nibName: "RepairListTableViewCell", bundle: .main), forCellReuseIdentifier: "RepairListTableViewCell")
        
        topRefresher.setEnable(isEnabled: true)
        topRefresher.position = .top
        tableView.addPullToRefresh(topRefresher, action: { [unowned self] in
            self.requestFirstPage().done { [weak self] in
                self?.tableView.endRefreshing(at: .top)
            }.cauterize()
        })
        
        bottomLoader.position = .bottom
        bottomLoader.setEnable(isEnabled: true)
        tableView.addPullToRefresh(bottomLoader, action: { [unowned self] in
            self.requestMore().done { [weak self] in
                self?.tableView.endRefreshing(at: .bottom)
            }.cauterize()
        })
        requestFirstPage().cauterize()
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

    init(flag: Int) {
        super.init(nibName: nil, bundle: nil)
        self.flag = flag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func reloadInfoOnAppear() {
        requestFirstPage().cauterize()
    }
    
    func requestFirstPage() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        requestData(page: 1).done { [weak self] rows in
            self?.rows = rows
            self?.tableView.reloadData()
            self?.page = 1
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestMore() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        requestData(page: page + 1).done{ [weak self] rows in
            if let total = self?.total,
               let count = self?.rows.count,
               total > count {
                self?.page += 1
                self?.rows.append(contentsOf: rows)
            } else {
                self?.rows = rows
            }
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestData(page: Int) -> Promise<[ListViolationElement]> {
        let (promise, resolver) = Promise<[ListViolationElement]>.pending()
        guard let userId = LoginManager.shared.user?.user.userId,
              let post = LoginManager.shared.user?.post.postType else {
            resolver.reject(Errors.Empty)
            return promise
        }
        
        if post == .siteManager {
            Service().listViolationByManager(
                ListViolationByManagerRequest.init(endTime: "", startTime: "", pageNum: page, pageSize: 20, peopleId: userId, type: flag)
            ).done { [weak self] result in
                switch result {
                case .success(let response):
                    guard let rows = response.data else {
                        return
                    }
                    self?.total = response.total
                    resolver.fulfill(rows)
                case .failure(let errorResp):
                    resolver.reject(Errors.requestError(message: errorResp.msg ?? "", code: errorResp.code))
                }
            }.catch{ error in
                print(error)
                resolver.reject(error)
            }
        } else if post == .excavateDriver || post == .truckDriver || post == .driver {
            Service().listViolationByDriver(
                ListViolationByDriverRequest.init(endTime: "", startTime: "", pageNum: page, pageSize: 20, userId: userId, type: flag)
            ).done { [weak self] result in
                switch result {
                case .success(let response):
                    guard let rows = response.data else {
                        return
                    }
                    self?.total = response.total
                    resolver.fulfill(rows)
                case .failure(let errorResp):
                    resolver.reject(Errors.requestError(message: errorResp.msg ?? "", code: errorResp.code))
                }
            }.catch{ error in
                print(error)
                resolver.reject(error)
            }
        }
        return promise
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepairListTableViewCell") as? RepairListTableViewCell,
              let element = rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.lb1.text = "车牌号"
        cell.lb2.text = "司机"
        cell.lb3.text = "违章类型"
        cell.lb4.text = "违章金额"
        cell.plateLb.text = element.plateNum
        cell.driverLb.text = element.creatorName
        cell.repairTypeLb.text = element.peccancyTypeName
        cell.priceLb.text = String(format: "%.2f", element.peccancyPrice ?? 0)
        cell.timeLb.text = element.peccancyTime
        guard let imageName = element.status?.imageNameForGasStatus() else {
            return cell
        }
        cell.statusImageView.image = UIImage(named: imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //0 司机提交 1 装点管理员确认 2 装点管理员驳回 3后台驳回 4后台审批通过
        guard let element = rows[safe: indexPath.row],
              let post = LoginManager.shared.user?.post.postType else {
            return
        }
        let vio =  ViolationDetailViewController()
        vio.violation = element
        vio.isEditable = (element.status == "2" || element.status == "3") && post != .siteManager
        navigationController?.pushViewController(vio, animated: true)
    }
}


