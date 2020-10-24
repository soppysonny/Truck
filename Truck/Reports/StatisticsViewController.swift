import UIKit
import DatePickerDialog
import Toast_Swift

class StatisticsViewController: BaseViewController {
    enum RecordType {
        case load
        case gas
        case violation
        case maintainence
        
        func title() -> String {
            switch self {
            case .load: return "装车费"
            case .gas: return "油费"
            case .violation: return "违章费"
            case .maintainence: return "维修保养费"
            }
        }
     
        func amountWithModel(_ model: ListTotalReportElement) -> String {
            switch self {
            case .load: return model.income ?? " - "
            case .gas: return "-" + (model.oilTotal ?? " 0.00 ")
            case .violation: return "-" + (model.peccancyPrice ?? "0.00")
            case .maintainence: return "-" + (model.repairPrice ?? "0.00")
            }
        }
    }

    let headerView = ReportHeaderView()
    let tableview = UITableView()
    let footer = TotalAmountFooterView()
    var startDate: Date = Date.now.weekBefore.midnight {
        didSet {
            headerView.label_1.text = startDate.toString(format: .debug2, locale: "zh_CN")
        }
    }
    var endDate: Date = Date.now.lastSecondOfDay {
        didSet {
            headerView.label_2.text = endDate.toString(format: .debug2, locale: "zh_CN")
        }
    }
    
    var totalReport: ListTotalReportElement?
    let cellTypes: [RecordType] = [.load, .gas, .violation, .maintainence]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "统计报表"
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
        
        let tableHeader = ReportTableHeaderView()
        view.addSubview(tableHeader)
        tableHeader.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.height.equalTo(40)
        })
        tableHeader.label_left.text = "费用类型"
        tableHeader.label_right.text = "价格"
        
        view.addSubview(footer)
        footer.snp.makeConstraints({ make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        })
        view.addSubview(tableview)
        tableview.backgroundColor = .white
        tableview.snp.makeConstraints({ make in
            make.top.equalTo(tableHeader.snp.bottom)
            make.left.equalTo(tableHeader.snp.left)
            make.right.equalTo(tableHeader.snp.right)
            make.bottom.equalTo(footer.snp.top)
        })
        tableview.register(UINib.init(nibName: "ReportTableViewCell", bundle: .main), forCellReuseIdentifier: "ReportTableViewCell")
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
        view.makeToastActivity(ToastPosition.center)
        let startDateStr = startDate.toString(format: .debug, locale: "zh_CN")
        let endDateStr = endDate.toString(format: .debug, locale: "zh_CN")
        Service.shared.listTotalReport(req: ListTotalReportRequest.init(companyId: cid, endDate: endDateStr, startDate: startDateStr, userId: uid)).done{ [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data,
                      let element = data[safe: 0] else {
                    self?.view.hideToastActivity()
                    return
                }
                self?.totalReport = element
                self?.tableview.reloadData()
                self?.loadFooter()
                self?.view.hideToastActivity()
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "")
            }
        }.catch({[weak self] err in
            self?.view.makeToast(err.localizedDescription)
        })
    }

    func loadFooter() {
        guard let model = totalReport else {
            return
        }
        guard let income = model.oilTotal,
              let incomeNum = Double(income),
              let gas = model.oilTotal,
              let gasNum = Double(gas),
              let violation = model.peccancyPrice,
              let violationNum = Double(violation),
              let maintein = model.repairPrice,
              let mainteinNum = Double(maintein)
              else {
            return
        }
        let total = incomeNum - gasNum - violationNum - mainteinNum
        let totalString = String.init(format: "%.2f 元", total)
        footer.amountLabel.text = totalString
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalReport == nil ? 0 : cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "ReportTableViewCell") as? ReportTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = cellTypes[indexPath.row].title()
        guard let model = totalReport else {
            return cell
        }
        cell.amountLabel.text = cellTypes[indexPath.row].amountWithModel(model)
        cell.amountLabel.textColor = cellTypes[indexPath.row] == .load ? .systemBlue : .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellTypes[indexPath.row] {
        case .load:
            let income = TruckDriverIncomeViewController()
            navigationController?.pushViewController(income, animated: true)
        default:
            break
        }
    }
    
}

extension StatisticsViewController: ReportHeaderViewProtocol {
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
            self?.endDate = date.lastSecondOfDay
        }
    }
    
    func buttonTapped() {
        requestData()
    }
}
