import UIKit

enum WorkbenchTaskStatusType {
    case confirmed
    case unconfirmed
    case processing
    case none
}

class WorkBenchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberPlateLb: UILabel!
    @IBOutlet weak var loadLocTel: UILabel!
    @IBOutlet weak var loadLocLb: UILabel!
    @IBOutlet weak var unloadLocLb: UILabel!
    @IBOutlet weak var unloadLocTel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    var status = WorkbenchTaskStatusType.none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configStatus(_ status: WorkbenchTaskStatusType) {
        switch status {
        case .confirmed:
            statusLabel.isHidden = false
            statusLabel.backgroundColor = .systemGreen
            statusLabel.text = "已确认"
        case .unconfirmed:
            statusLabel.isHidden = false
            statusLabel.backgroundColor = .systemOrange
            statusLabel.text = "已确认"
        case .processing, .none:
            statusLabel.isHidden = true
        }
    }
    
}
