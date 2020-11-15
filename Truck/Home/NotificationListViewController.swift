import UIKit
import MJRefresh
import PromiseKit

class NotificationListViewController: BaseViewController {
    var tableView = UITableView()
    let topRefresher = PullToRefresh()
    let bottomLoader = PullToRefresh()
    var page = 1
    var total: Int?
    var rows: ListMsgResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "通知"
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "MsgListTableViewCell", bundle: .main), forCellReuseIdentifier: "MsgListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
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
    }
    
    override func reloadInfoOnAppear() {
        requestFirstPage().cauterize()
    }
    
    func requestFirstPage() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        request(page: 1).done { [weak self] rows in
            self?.rows = rows
            self?.tableView.reloadData()
            self?.page = 1
            resolver.fulfill(())
            guard let msg = rows[safe: 0],
                  let timeStr = msg.createTime,
                  let time = timeStr.toDate(format: .debug, locale: "zh_CN")  else {
                return
            }
            PollingManager.shared.didRead(time: time)
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestMore() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        request(page: page + 1).done{ [weak self] rows in
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
    
    func request(page: Int) -> Promise<ListMsgResponse>{
        let (promise, resolver) = Promise<ListMsgResponse>.pending()
        guard let cid = LoginManager.shared.user?.company.companyId,
              let postType = LoginManager.shared.user?.post.postType,
              let uid = LoginManager.shared.user?.user.userId else {
            resolver.reject(Errors.Empty)
            return promise
        }
        
        Service.shared.listMsg(req: ListMsgRequest.init(companyId: cid, pageNum: page, postType: postType.rawValue, userId: uid)).done { result in
            switch result {
            case .success(let resp):
                guard let list = resp.data else {
                    resolver.reject(Errors.Empty)
                    return
                }
                resolver.fulfill(list)
            case .failure(let err):
                resolver.reject(Errors.requestError(message: err.msg ?? "", code: err.code))
            }
        }.catch({ error in
            resolver.reject(error)
        })
        return promise
    }
    
    
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MsgListTableViewCell") as? MsgListTableViewCell else {
            return UITableViewCell()
        }
        guard let msg = rows?[safe: indexPath.row] else {
            return cell
        }
        cell.titleLabel.text = msg.msgTitle
        cell.timeLabel.text = msg.createTime
        cell.nameLabel.text = msg.createName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let msg = rows?[safe: indexPath.row] else {
            return
        }
        switch msg.msgType {
        case .announce:
            navigationController?.pushViewController(AnnounceViewController(), animated: true)
        case .newTask, .dispatch:
            let task = MyTaskViewController()
            self.navigationController?.pushViewController(task, animated: true)
        default:
            guard let id = msg.msgId else {
                break
            }
            let detail = OrderDetailViewController()
            detail.task = WorkbenchListElement.init(companyId: nil, createTime: nil, dispatchId: nil, downId: nil, downName: nil, downPhone: nil, downWord: nil, driverId: nil, driverName: nil, id: id, isNormal: nil, isTransport: nil, linkman: nil, peopleId: nil, projectId: nil, projectName: nil, status: nil, transportAddress: nil, transportAddressName: nil, transportWord: nil, upId: nil, upManagerNickName: nil, upName: nil, upPhone: nil, upWord: nil, vehicleId: nil, vehiclePlateNum: "", step: nil)
            navigationController?.pushViewController(detail, animated: true)
            break
        }
    }
    
}
