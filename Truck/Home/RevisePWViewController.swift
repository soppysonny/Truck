import UIKit

class RevisePWViewController: BaseViewController {
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "修改密码"
        tableView = UITableView.init(frame: .zero)
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.register(UINib.init(nibName: "FormInputTableViewCell", bundle: .main), forCellReuseIdentifier: "FormInputTableViewCell")
        tableView.register(SingleButtonFooterView.self, forHeaderFooterViewReuseIdentifier: "SingleButtonFooterView")
        tableView.register(UINib.init(nibName: "FormTableViewCell", bundle: .main), forCellReuseIdentifier: "FormTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

}

extension RevisePWViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormTableViewCell") as? FormTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = "手机号"
            cell.infoLabel.text = LoginManager.shared.user?.user.phonenumber
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputTableViewCell") as? FormInputTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = indexPath.row == 1 ? "原密码" : "新密码"
            cell.textField.placeholder = indexPath.row == 1 ? "请输入原密码" : "请输入新密码"
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SingleButtonFooterView") as? SingleButtonFooterView else {
            return nil
        }
        footer.button.setTitle("修改密码", for: .normal)
        footer.buttonClosure = { [weak self] in
            self?.revisePW()
        }
        return footer
    }
    
    func revisePW() {
        guard let oldPWCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? FormInputTableViewCell,
            let newPWCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? FormInputTableViewCell else {
            return
        }
        
        guard let oldPW = oldPWCell.textField.text.trimmed(),
              oldPW.count > 0 else {
            view.makeToast("请输入原密码")
            return
        }
        
        guard let newPW = newPWCell.textField.text.trimmed(),
              newPW.count > 0 else {
            view.makeToast("请输入新密码")
            return
        }
        UserDefaults.standard.setValue(newPW, forKey: "pw")
        if let phone = LoginManager.shared.user?.user.phonenumber {
            UserDefaults.standard.setValue(newPW, forKey: phone)
        }
        Service.shared.changePW(oldPW: oldPW, newPW: newPW).done { [weak self] result in
            switch result {
            case .success(_):
                UIApplication.shared.keyWindow?.makeToast("修改密码成功")
                self?.tableView.visibleCells.forEach {
                    if let cell = $0 as? FormInputTableViewCell {
                        cell.textField.resignFirstResponder()
                    }
                }
                if let vcs = self?.navigationController?.viewControllers,
                   vcs.count == 1 {
                    RootViewController.shared.showHome()
                } else {
                    self?.navigationController?.popViewController(animated: true)
                }
            case .failure(let err):
                self?.view.makeToast(err.msg ?? "操作失败")
            }
        }.catch({ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
}
