import UIKit

class GasViewController: BaseViewController {
    let segment = UISegmentedControl.init(items: ["未审批", "已审批", "已驳回"])
    
    let unconfirmed = GasListViewController(flag: 0)
    let confirmed = GasListViewController(flag: 1)
    let rejected = GasListViewController(flag: 2)
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "加油"
        view.addSubview(segment)
        segment.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        })
        segment.tintColor = UIColor.segmentControlTintColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(GasViewController.segmentSelector), for: .valueChanged)
        addChild(confirmed)
        addChild(unconfirmed)
        addChild(rejected)
        view.addSubview(confirmed.view)
        view.addSubview(rejected.view)
        view.addSubview(unconfirmed.view)
        confirmed.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        unconfirmed.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        rejected.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        confirmed.view.layer.masksToBounds = true
        unconfirmed.view.layer.masksToBounds = true
        rejected.view.layer.masksToBounds = true
        guard let postType = LoginManager.shared.user?.post.postType,
              postType == .driver else {
            return
        }
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("上报加油", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        button.addTarget(self, action: #selector(applyGas), for: .touchUpInside)
    }


    @objc
    func segmentSelector() {
        switch segment.selectedSegmentIndex {
        case 2:
            view.bringSubviewToFront(rejected.view)
        case 0:
            view.bringSubviewToFront(unconfirmed.view)
        case 1:
            view.bringSubviewToFront(confirmed.view)
        default: break
        }
    }
    
    @objc
    func applyGas() {
        navigationController?.pushViewController(ApplyGasViewController(), animated: true)
    }
}
