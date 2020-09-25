import UIKit

class MyTaskViewController: BaseViewController {
    let segment = UISegmentedControl.init(items: ["待确认", "已确认"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestData(isConfirmed: true)
    }
    
    func setupUI() {
        title = "列表"
        view.addSubview(segment)
        segment.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        })
        segment.tintColor = UIColor.segmentControlTintColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(MyTaskViewController.segmentSelector), for: .valueChanged)
    }
    
    func requestData(isConfirmed: Bool) {
        guard let user = LoginManager.shared.user,
            let roleKey  = user.role.roleKey else { return }
        Service().taskList(userId: user.user.userId, status: isConfirmed ? "0" : "1", roleKey: roleKey).done { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let errorResp):
                print(errorResp.msg, errorResp.code)
            }
        }.catch{ error in
            print(error)
        }
    }

    @objc
    func segmentSelector() {
//        switch segment.selectedSegmentIndex {
//        case 0:
//
//        default:
//
//        }
    }
    
}
