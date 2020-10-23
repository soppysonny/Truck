import UIKit

class IncomeListTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_1: UILabel!
    @IBOutlet weak var lb_2: UILabel!
    @IBOutlet weak var lb_3: UILabel!
    @IBOutlet weak var lb_4: UILabel!
    @IBOutlet weak var lb_5: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
