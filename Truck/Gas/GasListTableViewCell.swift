import UIKit

class GasListTableViewCell: UITableViewCell {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var gasAmountLabel: UILabel!
    @IBOutlet weak var PlateNumLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var gasTypeLabel: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
