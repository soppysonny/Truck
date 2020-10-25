import UIKit

extension UITextField {
    func setInputAccessoryView() {
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = .default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                     target: self, action: nil)
        let commitButton = UIBarButtonItem(
            title: "完成",
            style: .done,
            target: self,
            action: #selector(resignFirstResponder)
        )
        commitButton.tintColor = UIColor.homeVoiceButtonColor
        kbToolBar.items = [spacer, commitButton]
        inputAccessoryView = kbToolBar
        tintColor = UIColor.homeVoiceButtonColor
    }
}

