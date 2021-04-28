//import UIKit
//class JSWebViewController: UIViewController {
//    lazy var webView : WKWebView = {
//        let config = WKWebViewConfiguration()
//        if #available(iOS 13.0, *) {
//            config.defaultWebpagePreferences.preferredContentMode = .mobile
//        } else {
//            
//        }
//        
//        let web = WKWebView(frame: .zero, configuration: config)
//        web.tintAdjustmentMode = .dimmed
//        web.scrollView.contentInsetAdjustmentBehavior = .never
//        web.uiDelegate = self
//        web.navigationDelegate = self
//        web.allowsBackForwardNavigationGestures = true
//        return web
//    }()
//}
