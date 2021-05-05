import UIKit

enum WorkbenchTaskStatusType {
    case confirmed
    case unconfirmed
    case abnormal
}

class WorkBenchListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var numberPlateLb: UILabel!
    @IBOutlet weak var loadLocLb: UILabel!
    @IBOutlet weak var unloadLocLb: UILabel!
    @IBOutlet weak var unloadLocTel: UILabel!
    
    @IBOutlet weak var statusImgView: UIImageView!
    
    @IBOutlet weak var deleteButton: UIButton!
    public var deleteBlock: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        unloadLocTel.setPhoneStyle()
    }

    @IBAction func deleteOrder(_ sender: Any) {
        deleteBlock?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configStatus(_ status: WorkbenchTaskStatusType) {
        switch status {
        case .confirmed:
            statusImgView.isHidden = false
            statusImgView.image = #imageLiteral(resourceName: "已确认")
            deleteButton.isHidden = true
        case .unconfirmed:
            statusImgView.isHidden = false
            statusImgView.image = #imageLiteral(resourceName: "待确认")
            deleteButton.isHidden = true
        case .abnormal:
            statusImgView.isHidden = false
            statusImgView.image = UIImage(named: "异常单")
            deleteButton.isHidden = false
        }
    }
    
    func configStep(_ step: String?) {
        guard let step = step,
              let stepNum = Int(step) else {
            return
        }
        var imgName = ""
        switch stepNum {
        case 0:
            imgName = "新运单"
        case 1:
            imgName = "到装点"
        case 2:
            imgName = "已装车"
        case 3:
            imgName = "已设卸点"
        case 4:
            imgName = "到卸点"
        case 5:
            imgName = "申请转运"
        case 6:
            imgName = "已设卸点"
        case 7:
            imgName = "到卸点"
        case 8:
            imgName = "已完成"
        default:
            statusImgView.isHidden = true
            return
        }
        statusImgView.isHidden = false
        deleteButton.isHidden = true
        statusImgView.image = UIImage(named: imgName)
    }
    
}


