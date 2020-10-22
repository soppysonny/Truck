import UIKit

enum TypeLabelType {
    case new
    case transfer
    case none
}

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var title_1: UILabel!
    @IBOutlet weak var title_2: UILabel!
    @IBOutlet weak var title_3: UILabel!
    @IBOutlet weak var title_4: UILabel!
    @IBOutlet weak var value_1: UILabel!
    @IBOutlet weak var value_2: UILabel!
    @IBOutlet weak var value_3: UILabel!
    @IBOutlet weak var value_4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 5
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowRadius = 3
        backView.layer.shadowOpacity = 0.05
        layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureType(_ type: TypeLabelType) {
        switch type {
        case .new:
            typeLabel.isHidden = false
            typeLabel.backgroundColor = #colorLiteral(red: 0.8784313725, green: 1, blue: 0.9843137255, alpha: 1)
            typeLabel.textColor = #colorLiteral(red: 0.06274509804, green: 0.7568627451, blue: 0.6862745098, alpha: 1)
            typeLabel.text = "新任务"
        case .transfer:
            typeLabel.isHidden = false
            typeLabel.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9490196078, blue: 0.937254902, alpha: 1)
            typeLabel.textColor = #colorLiteral(red: 1, green: 0.4274509804, blue: 0.2431372549, alpha: 1)
            typeLabel.text = "转运任务"
        case .none:
            typeLabel.isHidden = true
        }
    }
    
}
