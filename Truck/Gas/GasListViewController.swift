import UIKit
import PullToRefresh
import PromiseKit

class GasListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    var flag: Int = 1
    let tableView = UITableView()
    var rows: GetOilOutByCreateByResponse = []
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
        tableView.register(UINib.init(nibName: "GasListTableViewCell", bundle: .main), forCellReuseIdentifier: "GasListTableViewCell")
        
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
            self?.tableView.reloadData()
            self?.tableView.endRefreshing(at: .bottom)
            self?.tableView.endRefreshing(at: .top)
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestData(page: Int) -> Promise<GetOilOutByCreateByResponse> {
        let (promise, resolver) = Promise<GetOilOutByCreateByResponse>.pending()
        guard let userId = LoginManager.shared.user?.user.userId,
              let cid = LoginManager.shared.user?.company.companyId,
              let post = LoginManager.shared.user?.post.postType else {
            resolver.reject(Errors.Empty)
            return promise
        }
        
        if post == .driver {
            Service().getOilOutByCreateBy(GetOilOutByCreateByRequest.init(beginTime: "", companyId: cid, endTime: "", pageNum: page, type: flag, userId: userId)).done { [weak self] result in
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
        } else if post == .excavateDriver || post == .truckDriver {
            Service().listOilOutByDiverId(ListOilOutByDriverIdRequest.init(beginTime: "", endTime: "", pageNum: page, type: flag, userId: userId)).done { [weak self] result in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GasListTableViewCell") as? GasListTableViewCell,
              let element = rows[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.timeLabel.text = element.createTime
        cell.totalPriceLabel.text = String.init(format: "%.1f", element.total ?? 0)
        cell.gasAmountLabel.text = String.init(format: "%.1f", element.oilTonnage ?? 0)
        cell.PlateNumLabel.text = element.plateNum ?? ""
        cell.driverNameLabel.text = element.driverName
        cell.gasTypeLabel.text = element.oilType
        guard let imageName = element.status?.imageNameForGasStatus() else {
            return cell
        }
        cell.statusImgView.image = UIImage(named: imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let element = rows[safe: indexPath.row] else {
            return
        }
        if element.status == "2" || element.status == "3",
           let post = LoginManager.shared.user?.post.postType,
           post == .driver {
            let apply = ReviseGasViewController()
            apply.gasRecord = element
            navigationController?.pushViewController(apply, animated: true)
            return
        }
        let gasDetail = GasDetailViewController()
        gasDetail.gasRecord = element
        navigationController?.pushViewController(gasDetail, animated: true)
    }
}


