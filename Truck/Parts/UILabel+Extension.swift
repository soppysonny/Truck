import Foundation

extension UILabel {
    func setPhoneStyle() {
        textColor = .segmentControlTintColor
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapped)))
    }
    
    func setNormalStyle() {
        textColor = UIColor.fontColor_black_51
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapped)))
    }

    @objc
    func tapped() {
        guard let text = text,
              let url = URL(string: "tel://" + text) else {
            return
        }
        let webview = UIWebView()
        webview.loadRequest(URLRequest(url: url))
        UIApplication.shared.keyWindow?.addSubview(webview)
    }
}
