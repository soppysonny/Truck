import UIKit

class TaskListViewController: BaseViewController {
    var flag = Int(1)
    let tableView = UITableView()
    var rows = [MyTaskRow]()
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData(isConfirmed: flag == 1)
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
        
    }
    
    init(flag: Int) {
        super.init(nibName: nil, bundle: nil)
        self.flag = flag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func requestData(isConfirmed: Bool) {
        guard let user = LoginManager.shared.user,
            let roleKey  = user.role.roleKey else { return }
        Service().taskList(userId: user.user.userId, status: isConfirmed ? "0" : "1", roleKey: roleKey).done { result in
            switch result {
            case .success(let response):
                print(response)
                
            case .failure(let errorResp):
                print(errorResp.msg, errorResp.code)
            }
        }.catch{ error in
            print(error)
        }
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return rows.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as? TaskListTableViewCell else {
            fatalError()
        }
        cell.configureType(indexPath.row % 2 == 0 ? .new : .transfer)
        cell.value_1.text = "苏E123123"
        cell.value_2.text = "****工程"
        cell.value_3.text = "199999999"
        
        cell.configureType(indexPath.row % 2 == 0 ? .new : .transfer)
        
//        let row = rows[indexPath.row]
//        cell.value_1.text = row.vehicleNo
//        cell.value_2.text = row.projectName
//        cell.value_3.text = row.
//        cell.configureType(row.objectType)
        return cell
    }
    
    
}
