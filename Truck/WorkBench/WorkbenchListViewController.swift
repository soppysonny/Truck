import UIKit
import MJRefresh
import PromiseKit

enum WorkbenchListType {
    case abnormal
    case finished
    case processing
}

class WorkbenchListViewController: BaseViewController {
    let tableView = UITableView()
    var rows: WorkbenchList?
    var page = 1
    var total: Int?
    var type: WorkbenchListType = .processing
    var didScrollBlock: (()->())?
    var plateNum: String? {
        didSet {
            requestFirstPage().cauterize()
        }
    }
    init(type: WorkbenchListType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "WorkBenchListTableViewCell", bundle: .main), forCellReuseIdentifier: "WorkBenchListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            self?.requestFirstPage().done { [weak self] in
                self?.tableView.mj_header?.endRefreshing()
            }.cauterize()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [weak self] in
            self?.tableView.mj_footer?.endRefreshing()
        })
        
        requestFirstPage().cauterize()
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
               let count = self?.rows?.count,
               total > count {
                self?.page += 1
                self?.rows?.append(contentsOf: rows)
            } else {
                self?.rows = rows
            }
            self?.tableView.reloadData()
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestData(page: Int) -> Promise<WorkbenchList> {
        let (promise, resolver) = Promise<WorkbenchList>.pending()
        guard let userId = LoginManager.shared.user?.user.userId,
              let companyId = LoginManager.shared.user?.company.companyId else {
            resolver.reject(Errors.Empty)
            return promise
        }
        Service.shared.workbenchList(type: type,
                                     companyId: companyId,
                                     pageNum: page,
                                     userId: userId,
                                     plateNum: plateNum).done { result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    resolver.reject(Errors.Empty)
                    return
                }
                resolver.fulfill(data)
            case .failure(let error):                
                resolver.reject(Errors.requestError(message: error.msg ?? "", code: error.code))
            }
        }.catch { error in
            resolver.reject(error)
        }
        return promise
    }
    
    
}

extension WorkbenchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "WorkBenchListTableViewCell") as? WorkBenchListTableViewCell else {
            return UITableViewCell()
        }
        guard let row = rows?[indexPath.row] else {
            return cell
        }
        cell.numberPlateLb.text = row.vehiclePlateNum
        cell.loadLocLb.text = row.upName
        cell.unloadLocLb.text = row.downName
        cell.loadLocTel.text = row.upPhone
        cell.unloadLocTel.text = row.downPhone
        
        if let status = row.status,
           Int(status) == 1 {
           if let isNormal = row.isNormal,
              Int(isNormal) != 2 {
                if Int(isNormal) != 0 {
                    cell.configStatus(.confirmed)
                } else {
                    cell.configStatus(.unconfirmed)
                }
           } else {
            cell.configStatus(.abnormal)
           }
        } else {
            guard let step = row.step else {
                return cell
            }
            cell.configStep(step)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = rows?[indexPath.row] else {
            return
        }
        let detail = OrderDetailViewController()
        detail.task = row
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scroll = didScrollBlock else {
            return
        }
        scroll()
    }
    
}
