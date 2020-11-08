import UIKit
import DatePickerDialog

class RepairDetailViewController: BaseViewController {
    enum CellType {
        case plateNum
        case driver
        case repairPrice
        case repairType
        case startTime
        case endTime
        case image(imgs: [ImageListElement])
        case reason(reason: String)
        
        static func types(repairModel: ListRepairElement?) -> [CellType] {
            guard let model = repairModel else {
                return [CellType]()
            }
            var types:[CellType] = [
                .plateNum,
                .driver,
                .repairPrice,
                .repairType,
                .startTime,
                .endTime,
            ]
            if let imgs = model.imageList,
               imgs.count > 0 {
                types.append(.image(imgs: imgs))
            }
            if let rejectReason = model.rejectReason {
                types.append(.reason(reason: rejectReason))
            }
            return types
        }
        
        func title() -> String {
            switch self {
            case .plateNum:
                return "车辆信息:"
            case .driver:
                return "司机:"
            case .repairPrice:
                return "维修价格:"
            case .repairType:
                return "维修类型:"
            case .startTime:
                return "开始日期:"
            case .endTime:
                return "结束如期:"
            case .image:
                return "照片:"
            case .reason:
                return "驳回理由"
            }
        }
    }
    
    let tableView = UITableView()
    var cellTypes = [CellType]()
    let footerButton = UIButton()
    var repairModel: ListRepairElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "维修"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.register(UINib.init(nibName: "FormTextViewTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTextViewTableViewCell")
        cellTypes = CellType.types(repairModel: repairModel)
        tableView.reloadData()
//        tableView.separatorInset = .init(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    }

}

extension RepairDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = cellTypes[safe: indexPath.row],
              let repairModel = repairModel else {
            return UITableViewCell()
        }
        
        switch type {
        case .image(let imgs):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.isEditable = false
            cell.imageElements = imgs
            return cell
        case .reason(let reason):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTextViewTableViewCell") as? FormTextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = type.title()
            cell.textView.text = reason
            return cell
        default:
            break
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = type.title()
        switch type {
        case .plateNum:
            cell.infoLabel.text = repairModel.plateNum
        case .repairPrice:
            cell.infoLabel.text = String.init(format: "%.1f", repairModel.repairPrice ?? 0)
        case .repairType:
            cell.infoLabel.text = repairModel.repairTypeName ?? ""
        case .startTime:
            cell.infoLabel.text = repairModel.startTime ?? ""
        case .endTime:
            cell.infoLabel.text = repairModel.endTime ?? ""
        case .driver:
            cell.infoLabel.text = repairModel.driverName ?? ""
        default: break
        }
        return cell
    }
    
    
   
}
