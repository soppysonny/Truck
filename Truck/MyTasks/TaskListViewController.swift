import UIKit
import PullToRefresh
import PromiseKit
class TaskListViewController: BaseViewController {
    var flag = Int(1)
    let tableView = UITableView()
    var rows = [MyTaskRow]()
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
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        tableView.register(UINib.init(nibName: "TaskListTableViewCell", bundle: .main), forCellReuseIdentifier: "TaskListTableViewCell")
        
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
            resolver.fulfill(())
        }.catch({ [weak self] error in
            resolver.reject(error)
            self?.view.makeToast(error.localizedDescription)
        })
        return promise
    }
    
    func requestData(page: Int) -> Promise<[MyTaskRow]> {
        let (promise, resolver) = Promise<[MyTaskRow]>.pending()
        guard let user = LoginManager.shared.user,
            let postType = user.post.postType else {
            resolver.reject(Errors.Empty)
            return promise
        }
        Service().taskList(userId: user.user.userId, status: self.flag, postType: postType.rawValue, pageNum: page).done { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
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
        return promise
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as? TaskListTableViewCell else {
            fatalError()
        }
        let task = rows[indexPath.row]
        cell.configureType(.none)
        cell.value_1.text = task.upAddressName
        
        cell.value_2.text = task.phonenumber
        
        cell.value_3.text = task.upWord
        
        cell.value_4.text = task.dispatchStartTime
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = TaskDetailViewController.init(nibName: "TaskDetailViewController", bundle: .main)
        taskVC.task = rows[indexPath.row]
        navigationController?.pushViewController(taskVC, animated: true)
    }
    
}
