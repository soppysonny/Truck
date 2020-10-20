import UIKit
import Toast_Swift

protocol FormSelectDelegate: class {
    func didSelect(_ indexPath: IndexPath)
}

class FormSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    weak var delegate: FormSelectDelegate?
    var titles: [String]?
    var defaultInfoText = "请选择地址"
    var selectedIndexPath: IndexPath? = nil {
        didSet {
            guard let indexpath = selectedIndexPath else {
                infoLabel.text = defaultInfoText
                infoLabel.textColor = .lightGray
                return
            }
            guard let titles = titles,
                  titles.count - 1 >= indexpath.row else {
                return
            }
            infoLabel.textColor = .black
            infoLabel.text = titles[indexpath.row]
            delegate?.didSelect(indexpath)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        selectionStyle = .none
        selectedIndexPath = nil
        infoLabel.text = defaultInfoText
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(showMenu)))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc
    func showMenu() {
        guard let titles = titles else {
            UIApplication.shared.keyWindow?.makeToast("没有可选的地址")
            return
        }
        DropDownMenu.showWithTitles(titles, attachedView: self, height: 200, delegate: self, selectedIndexPath: selectedIndexPath)
    }
    
}

extension FormSelectTableViewCell: DropDownMenuProtocol {
    func selected(indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
    }
    
    func deselected() {
        selectedIndexPath = nil
    }
    
    func dismissed() {
        
    }
}
