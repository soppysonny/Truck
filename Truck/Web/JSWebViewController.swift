import WebKit
import UIKit

enum WebType {
    case vehicleManage
    case more
    var title: String {
        switch self {
        case .vehicleManage:
            return "车辆管理"
        case .more:
            return "更多"
        default:
            return ""
        }
    }
    
    var url: URL? {
        guard let token = LoginManager.shared.user?.token else {
            return nil
        }
        return URL.init(string: baseWebUrlString +
                            "app/CarManage/" +
                            "?appToken=" +
                            token +
                            "&isMobile=True")
    }
}

class JSWebViewController: BaseViewController, WKUIDelegate, WKNavigationDelegate {
    var webType: WebType
    init(webType: WebType) {
        self.webType = webType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        if #available(iOS 13.0, *) {
            config.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        let web = WKWebView(frame: .zero, configuration: config)
        web.tintAdjustmentMode = .dimmed
        web.scrollView.contentInsetAdjustmentBehavior = .never
        web.uiDelegate = self
        web.navigationDelegate = self
        web.allowsBackForwardNavigationGestures = true
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = webType.title
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let url = webType.url {
            webView.load(URLRequest.init(url: url))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFailed {
            webView.reload()
        }
    }
    
    var isFailed = false
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
        // https://stackoverflow.com/questions/45131361/how-do-i-properly-implement-didfailprovisionalnavigation-with-wkwebview
        guard error._code != 999 else {
            return
        }
       isFailed = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        isFailed = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse else {
            return
        }
        if response.statusCode == 200 {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // https://blog.csdn.net/github_34613936/article/details/51490032
        switch challenge.protectionSpace.authenticationMethod {
        case NSURLAuthenticationMethodServerTrust:
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!);
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        default:
            break
        }
    }
}
