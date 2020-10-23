import UIKit
import DatePickerDialog
import Toast_Swift
class TruckDriverIncomeViewController: BaseViewController {
    let headerView = ReportHeaderView()
    let tableview = UITableView()
//    let footer = TotalAmountFooterView()
    var startDate: Date = Date.now.weekBefore {
        didSet {
            headerView.label_1.text = startDate.toString(format: .debug2, locale: "zh_CN")
        }
    }
    var endDate: Date = Date.now {
        didSet {
            headerView.label_2.text = endDate.toString(format: .debug2, locale: "zh_CN")
        }
    }
    var response: ListDetailReportResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "报表详情"
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        view.addSubview(headerView)
        headerView.snp.makeConstraints({ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        })
        headerView.delegate = self
        headerView.label_1.text = startDate.toString(format: .debug2, locale: "zh_CN")
        headerView.label_2.text = endDate.toString(format: .debug2, locale: "zh_CN")
        
        let tableHeader = IncomeHeaderView()
        view.addSubview(tableHeader)
        tableHeader.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.height.equalTo(40)
        })
        
//        view.addSubview(footer)
//        footer.snp.makeConstraints({ make in
//            make.left.bottom.right.equalToSuperview()
//            make.height.equalTo(60)
//        })
        view.addSubview(tableview)
        tableview.backgroundColor = .white
        tableview.snp.makeConstraints({ make in
            make.top.equalTo(tableHeader.snp.bottom)
            make.left.equalTo(tableHeader.snp.left)
            make.right.equalTo(tableHeader.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.bottom.equalTo(footer.snp.top)
        })
        tableview.register(UINib.init(nibName: "IncomeListTableViewCell", bundle: .main), forCellReuseIdentifier: "IncomeListTableViewCell")
        tableview.tableFooterView = UIView()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = UITableView.automaticDimension
        requestData()
    }
    
    func requestData() {
        guard let cid = LoginManager.shared.user?.company.companyId,
              let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        let startDateStr = startDate.toString(format: .debug, locale: "zh_CN")
        let endDateStr = endDate.toString(format: .debug, locale: "zh_CN")
        Service.shared.listDetailReport(req: ListDetailReportRequest.init(companyId: cid, endDate: endDateStr, startDate: startDateStr, userId: uid)).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.response = data
                self?.tableview.reloadData()
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "")
            }
        }.catch { [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
}

extension TruckDriverIncomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.response?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "IncomeListTableViewCell") as? IncomeListTableViewCell else {
            return UITableViewCell()
        }
        guard let element = response?[safe: indexPath.row] else {
            return cell
        }
        cell.lb_1.text = element.addressName
        cell.lb_2.text = element.downName
        cell.lb_3.text = element.mileage
        cell.lb_4.text = element.price
        cell.lb_5.text = element.totalPrice
        return cell
    }
    
}

extension TruckDriverIncomeViewController: ReportHeaderViewProtocol {
    func tapLeftTimeLabel() {
        let dialog = DatePickerDialog(locale: Locale.init(identifier: "zh_CN"))
        dialog.show("起始时间",
                    doneButtonTitle: "确定",
                    cancelButtonTitle: "取消",
                    defaultDate: startDate,
                    maximumDate: endDate,
                    datePickerMode: .date) { [weak self] date in
            guard let date = date else {
                return
            }
            self?.startDate = date
        }
    }
    
    func tapRightTimeLabel() {
        let dialog = DatePickerDialog(locale: Locale.init(identifier: "zh_CN"))
        dialog.show("结束时间",
                    doneButtonTitle: "确定",
                    cancelButtonTitle: "取消",
                    defaultDate: endDate,
                    minimumDate: startDate,
                    maximumDate: Date.now,
                    datePickerMode: .date) { [weak self] date in
            guard let date = date else {
                return
            }
            self?.endDate = date
        }
    }
    
    func buttonTapped() {
        requestData()
    }
}
