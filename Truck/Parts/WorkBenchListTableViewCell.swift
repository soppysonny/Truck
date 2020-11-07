import UIKit

enum WorkbenchTaskStatusType {
    case confirmed
    case unconfirmed
    case processing
    case abnormal
    case none
}

class WorkBenchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberPlateLb: UILabel!
    @IBOutlet weak var loadLocTel: UILabel!
    @IBOutlet weak var loadLocLb: UILabel!
    @IBOutlet weak var unloadLocLb: UILabel!
    @IBOutlet weak var unloadLocTel: UILabel!
    
    @IBOutlet weak var statusImgView: UIImageView!
    var status = WorkbenchTaskStatusType.none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        loadLocTel.setPhoneStyle()
        unloadLocTel.setPhoneStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configStatus(_ status: WorkbenchTaskStatusType) {
        switch status {
        case .confirmed:
            statusImgView.isHidden = false
            statusImgView.image = #imageLiteral(resourceName: "已确认")
        case .unconfirmed:
            statusImgView.isHidden = false
            statusImgView.image = #imageLiteral(resourceName: "待确认")
        case .processing, .none:
            statusImgView.isHidden = true
        case .abnormal:
            statusImgView.isHidden = false
        }
    }
    
}
