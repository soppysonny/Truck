import UIKit

class RepairViewController: BaseViewController {
    let segment = UISegmentedControl.init(items: ["未审批", "已审批", "已驳回"])
    let unconfirmed = RepairListViewController(flag: 0)
    let confirmed = RepairListViewController(flag: 1)
    let rejected = RepairListViewController(flag: 2)
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "维修"
        view.addSubview(segment)
        segment.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        })
        segment.tintColor = UIColor.segmentControlTintColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(RepairViewController.segmentSelector), for: .valueChanged)
        addChild(rejected)
        addChild(confirmed)
        addChild(unconfirmed)
        view.addSubview(rejected.view)
        view.addSubview(confirmed.view)
        view.addSubview(unconfirmed.view)
        rejected.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
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
        confirmed.view.layer.masksToBounds = true
        unconfirmed.view.layer.masksToBounds = true

        guard let postType = LoginManager.shared.user?.post.postType,
              (postType == .driver || postType == .truckDriver || postType == .excavateDriver) else {
            return
        }
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("上报维修", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        button.addTarget(self, action: #selector(applyRepair), for: .touchUpInside)
    }

    @objc
    func segmentSelector() {
        switch segment.selectedSegmentIndex {
        case 0:
            view.bringSubviewToFront(unconfirmed.view)
        case 1:
            view.bringSubviewToFront(confirmed.view)
        case 2:
            view.bringSubviewToFront(rejected.view)
        default: break
        }
    }

    @objc
    func applyRepair() {
        navigationController?.pushViewController(ApplyRepairViewController(), animated: true)
    }
}
