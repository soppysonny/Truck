import UIKit

class WorkBenchViewController: BaseViewController {
    let segment = UISegmentedControl.init(items: ["待确认", "已确认", "运输中", "完成", "异常"])
    let toConfirmTaskList = TaskListViewController(flag: 0)
    let confirmedTaskList = TaskListViewController(flag: 1)
    let processingTaskList = TaskListViewController(flag: 2)
    let completeTaskList = TaskListViewController(flag: 3)
    let abnormalTaskList = TaskListViewController(flag: 4)
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
        
        addChild(toConfirmTaskList)
        addChild(confirmedTaskList)
        addChild(processingTaskList)
        addChild(completeTaskList)
        addChild(abnormalTaskList)
        view.addSubview(toConfirmTaskList.view)
        toConfirmTaskList.view.snp.makeConstraints({ make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(segment.snp.bottom)
        })
    }
    
    @objc
    func segmentSelector() {
        var listVC = toConfirmTaskList
        switch segment.selectedSegmentIndex {
        case 1:
            listVC = confirmedTaskList
            break
        case 2:
            listVC = processingTaskList
            break
        case 3:
            listVC = completeTaskList
            break
        case 4:
            listVC = abnormalTaskList
            break
        default:
            break
        }
        if listVC.view.superview != nil {
            view.bringSubviewToFront(listVC.view)
        } else {
            view.addSubview(listVC.view)
            listVC.view.snp.remakeConstraints({ make in
                   make.bottom.left.right.equalToSuperview()
                   make.top.equalTo(segment.snp.bottom)
               })
        }
    }
    
}
