import UIKit

enum PHLBStyle {
    case normal
    case phone
}

class PhoneNumLabel: UILabel {
    var style = PHLBStyle.phone {
        didSet {
            switch style {
            case .normal:
                textColor = .plainTextColor
                isUserInteractionEnabled = false
            case .phone:
                textColor = .segmentControlTintColor
                isUserInteractionEnabled = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .segmentControlTintColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        textColor = .segmentControlTintColor
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedGesture)))
    }
    
    @objc
    func tappedGesture() {
        guard let text = text,
              let url = URL(string: "tel://" + text) else {
            return
        }
        let webview = UIWebView()
        webview.loadRequest(URLRequest(url: url))
        UIApplication.shared.keyWindow?.addSubview(webview)
    }
    
    
    
}
