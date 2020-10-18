import UIKit

class MyTaskViewController: BaseViewController {
    let segment = UISegmentedControl.init(items: ["待确认", "已确认"])
    let tasklist_unconfirmed = TaskListViewController.init(flag: 0)
    let tasklist_confirmed = TaskListViewController.init(flag: 1)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        addChild(tasklist_confirmed)
        addChild(tasklist_unconfirmed)
        view.addSubview(tasklist_confirmed.view)
        view.addSubview(tasklist_unconfirmed.view)
        tasklist_confirmed.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tasklist_unconfirmed.view.snp.makeConstraints({ make in
            make.top.equalTo(segment.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tasklist_confirmed.view.layer.masksToBounds = true
        tasklist_unconfirmed.view.layer.masksToBounds = true
    }


    @objc
    func segmentSelector() {
        switch segment.selectedSegmentIndex {
        case 0:
            view.bringSubviewToFront(tasklist_unconfirmed.view)
        default:
            view.bringSubviewToFront(tasklist_confirmed.view)
        }
    }
    
}
