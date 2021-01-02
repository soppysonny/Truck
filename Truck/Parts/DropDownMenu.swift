import Foundation
import UIKit
protocol DropDownMenuProtocol {
    func selected(indexPath: IndexPath)
    func deselected()
    func dismissed()
}

class DropDownMenu: UIView {
    let tableview = UITableView()
    var delegate: DropDownMenuProtocol?
    var titles = [String]() {
        didSet {
            tableview.reloadData()
        }
    }
    var selectionTextColor = #colorLiteral(red: 0.2196078431, green: 0.4980392157, blue: 1, alpha: 1)
    var textColor = UIColor.black
    var font = UIFont.systemFont(ofSize: 20, weight: .medium)
    var cellHeight: CGFloat = 40
    var selectedIndexPath: IndexPath?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let cancelButton = UIButton()
        addSubview(cancelButton)
        addSubview(tableview)
        cornerRadius = 5
        borderColor = .lightGray
        borderWidth = 0.5
        tableview.delegate = self
        tableview.dataSource = self
        tableview.snp.makeConstraints({ make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(cancelButton.snp.top)
        })
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownMenuCell")
        
        cancelButton.snp.makeConstraints({ make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(35)
        })
        
        cancelButton.setTitleColor(#colorLiteral(red: 0.2196078431, green: 0.4980392157, blue: 1, alpha: 1), for: .normal)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(DropDownMenu.cancel), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func cancel() {
        delegate?.dismissed()
        removeFromSuperview()
    }
    
    static func showWithTitles(_ titles: [String],
                               attachedView: UIView,
                               height: CGFloat,
                               delegate: DropDownMenuProtocol,
                               selectedIndexPath: IndexPath? = nil,
                               font: UIFont = UIFont.systemFont(ofSize: 20, weight: .medium),
                               textColor: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),
                               selectionTextColor: UIColor = #colorLiteral(red: 0.2196078431, green: 0.4980392157, blue: 1, alpha: 1),
                               cellHeight: CGFloat = 30) {
        let menu = DropDownMenu.init(frame: CGRect.zero)
        menu.textColor = textColor
        menu.selectionTextColor = selectionTextColor
        menu.font = font
        menu.cellHeight = cellHeight
        menu.titles = titles
        menu.delegate = delegate
        menu.selectedIndexPath = selectedIndexPath
        attachedView.superview?.addSubview(menu)
        menu.snp.makeConstraints({ make in
            make.width.equalTo(attachedView)
            make.top.equalTo(attachedView.snp.bottom)
            make.left.equalTo(attachedView.snp.left)
            make.height.equalTo(height)
        })
    }
    
}

extension DropDownMenu: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownMenuCell", for: indexPath)
        cell.separatorInset = UIEdgeInsets.zero
        cell.textLabel?.text = titles[indexPath.row]
        cell.textLabel?.font = font
        cell.textLabel?.textColor = indexPath == selectedIndexPath ? selectionTextColor : textColor
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
            delegate.deselected()
        } else {
            selectedIndexPath = indexPath
            delegate.selected(indexPath: indexPath)
            removeFromSuperview()
        }
        tableView.reloadData()
    }
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
    
}

