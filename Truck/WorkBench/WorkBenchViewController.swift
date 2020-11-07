import UIKit

class WorkBenchViewController: BaseViewController, UISearchBarDelegate {
    let segment = UISegmentedControl.init(items: ["运输中", "已完成", "异常中"])
    let processingTaskList = WorkbenchListViewController(type: .processing)
    let completeTaskList = WorkbenchListViewController(type: .finished)
    let abnormalTaskList = WorkbenchListViewController(type: .abnormal)
    let searchBar = UISearchBar.init(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "工作台"
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
        })
        searchBar.showsCancelButton = true
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.placeholder = "请输入车牌号"
        } else {
            searchBar.placeholder = "请输入车牌号"
        }
        view.addSubview(segment)
        segment.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.height.equalTo(30)
        })
        searchBar.delegate = self
        
        segment.tintColor = UIColor.segmentControlTintColor
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(MyTaskViewController.segmentSelector), for: .valueChanged)
        
        processingTaskList.didScrollBlock = { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
        completeTaskList.didScrollBlock = { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
        abnormalTaskList.didScrollBlock = { [weak self] in
            self?.searchBar.resignFirstResponder()
        }
        
        addChild(processingTaskList)
        addChild(completeTaskList)
        addChild(abnormalTaskList)
        view.addSubview(processingTaskList.view)
        processingTaskList.view.snp.makeConstraints({ make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(segment.snp.bottom)
        })
    }
    
    @objc
    func segmentSelector() {
        var listVC = processingTaskList
        switch segment.selectedSegmentIndex {
        case 0:
            listVC = processingTaskList
        case 1:
            listVC = completeTaskList
        case 2:
            listVC = abnormalTaskList
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
        
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        processingTaskList.plateNum = searchBar.text
        completeTaskList.plateNum = searchBar.text
        abnormalTaskList.plateNum = searchBar.text
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
    }
    
}
