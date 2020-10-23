
import UIKit
import PullToRefresh
import PromiseKit

class AnnounceListViewController: BaseViewController {
    let tableView = UITableView()
    let topRefresher = PullToRefresh()
    let bottomLoader = PullToRefresh()
    var page = 1
    var total: Int?
    var rows: [ListNoticeResponse]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "公告"
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        })
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "AnnounceListTableViewCell", bundle: .main), forCellReuseIdentifier: "AnnounceListTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        topRefresher.setEnable(isEnabled: true)
        topRefresher.position = .top
        tableView.addPullToRefresh(topRefresher, action: { [unowned self] in
            requestFirstPage().done { [weak self] in
                self?.tableView.endRefreshing(at: .top)
            }.cauterize()
        })
        
        bottomLoader.position = .bottom
        bottomLoader.setEnable(isEnabled: true)
        tableView.addPullToRefresh(bottomLoader, action: { [unowned self] in
            requestMore().done { [weak self] in
                self?.tableView.endRefreshing(at: .bottom)
            }.cauterize()
        })
        
        requestFirstPage().cauterize()
    }
    
    
    func requestFirstPage() -> Promise<Void> {
        let (promise, resolver) = Promise<Void>.pending()
        request(page: 1).done { [weak self] rows in
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
            self?.tableView.endRefreshing(at: .bottom)
            self?.tableView.endRefreshing(at: .top)
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func request(page: Int) -> Promise<[ListNoticeResponse]>{
        let (promise, resolver) = Promise<[ListNoticeResponse]>.pending()
        guard let cid = LoginManager.shared.user?.company.companyId else {
            resolver.reject(Errors.Empty)
            return promise
        }
        Service.shared.listNotice(req: ListNoticeRequest.init(companyId: cid, pageNum: page)).done { result in
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

extension AnnounceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounceListTableViewCell") as? AnnounceListTableViewCell else {
            return UITableViewCell()
        }
        guard let notice = rows?[safe: indexPath.row] else {
            return cell
        }
        cell.titleLabel.text = notice.title
        cell.contentLabel.text = notice.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let notice = rows?[safe: indexPath.row] else {
            return
        }
        let noticevc = AnnounceDetailViewController()
        noticevc.title = "公告详情"
        noticevc.announce = notice
        navigationController?.pushViewController(noticevc, animated: true)
    }
    
}
