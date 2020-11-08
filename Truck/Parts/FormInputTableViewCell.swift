import UIKit

protocol FormInputProtocol: class {
    func textDidChange(cell: FormInputTableViewCell)
}

class FormInputTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    weak var delegate: FormInputProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(notification:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
    }
    
    @objc
    func textDidChange(notification: Notification) {
        delegate?.textDidChange(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
