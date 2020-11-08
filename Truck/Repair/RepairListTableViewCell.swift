import UIKit

class RepairListTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var plateLb: UILabel!
    @IBOutlet weak var driverLb: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var repairTypeLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
