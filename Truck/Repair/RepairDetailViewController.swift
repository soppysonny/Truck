import UIKit
import DatePickerDialog

class RepairDetailViewController: BaseViewController {
    enum CellType {
        case plateNum
        case repairPrice
        case repairType
        case startTime
        case endTime
        case image
        static func types() -> [CellType] {
            return [
                .plateNum,
                .repairPrice,
                .repairType,
                .startTime,
                .endTime,
                .image
            ]
        }
        
        func title() -> String {
            switch self {
            case .plateNum:
                return "车辆信息:"
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
            }
        }
    }
    
    let tableView = UITableView()
    let cellTypes = CellType.types()
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-60)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(ChangeProfileAlbumTableViewCell.self, forCellReuseIdentifier: "ChangeProfileAlbumTableViewCell")
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        
        
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
        
        if type == .image {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileAlbumTableViewCell") as? ChangeProfileAlbumTableViewCell else {
                return UITableViewCell()
            }
            cell.isEditable = false
            let images: [ImageListElement]? = repairModel.images?.map {
                ImageListElement.init(name: nil, url: $0)
            }
            cell.imageElements = images
            return cell
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
            cell.infoLabel.text = repairModel.repairType ?? ""
        case .startTime:
            cell.infoLabel.text = repairModel.startTime ?? ""
        case .endTime:
            cell.infoLabel.text = repairModel.endTime ?? ""
        default: break
        }
        return cell
    }
    
    
   
}
