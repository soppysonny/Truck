import UIKit
import Toast_Swift

protocol FormSelectDelegate: class {
    func didSelect(_ indexPath: IndexPath, cell: FormSelectTableViewCell)
}

class FormSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: FormSelectDelegate?
    var titles: [String]?
    var defaultInfoText = "请选择地址" {
        didSet {
            guard selectedIndexPath != nil else {
                button.setTitle(defaultInfoText, for: .normal)
                button.setTitleColor(.white, for: .normal)
                return
            }
        }
    }
    var defaultAlertText = "没有可选的地址"
    var selectedIndexPath: IndexPath? = nil {
        didSet {
            guard let indexpath = selectedIndexPath else {
                button.setTitle(defaultInfoText, for: .normal)
                button.setTitleColor(.white, for: .normal)
                return
            }
            guard let titles = titles,
                  titles.count - 1 >= indexpath.row else {
                return
            }
            button.setTitle(titles[indexpath.row], for: .normal)
            button.setTitleColor(.black, for: .normal)
            delegate?.didSelect(indexpath, cell: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        contentView.layer.masksToBounds = false
        selectionStyle = .none
        selectedIndexPath = nil
        button.setTitle(defaultInfoText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    }
    
    func presetValue(_ val: String) {
        button.setTitle(val, for: .normal)
        button.setTitleColor(.black, for: .normal)
    }

    func reset() {
        button.setTitle(defaultInfoText, for: .normal)
        button.setTitleColor(.white, for: .normal)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @objc
    func showMenu() {
        guard let titles = titles else {
            UIApplication.shared.keyWindow?.makeToast(self.defaultAlertText)
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
