import UIKit

class GasListTableViewCell: UITableViewCell {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var gasAmountLabel: UILabel!
    @IBOutlet weak var PlateNumLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
