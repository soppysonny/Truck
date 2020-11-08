import UIKit
import Kingfisher
class NewsDetailViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    enum CellType {
        case title(title: String?, time: String?)
        case image(url: String)
        case content(content: String?)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celltype = cellTypes[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch celltype {
        case .title(let title, let time):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTitleTableViewCell") as? NewsTitleTableViewCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = title
            cell.timeLable.text = time
            return cell
        case .image(let url):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageTableViewCell") as? NewsImageTableViewCell else {
                return UITableViewCell()
            }
            cell.imgView.kf.setImage(with: URL.init(string: url))
//            cell.imgView.sizeToFit()
            return cell
        case .content(let content):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsContentTableViewCell") as? NewsContentTableViewCell else {
                return UITableViewCell()
            }
            cell.contentLb.text = content
            cell.contentLb.sizeToFit()
            return cell
            
        }
    }
    var cellTypes = [CellType]()
    var news: ListNewsResponse?
    var newsDetail: NewsDetailResponse? {
        didSet {
            cellTypes = [
                .title(title: newsDetail?.title, time: newsDetail?.createTime),
            ]
            if let imgs = newsDetail?.imageList {
                for (_, ele) in imgs.enumerated() {
                    if let url = ele.url {
                        cellTypes.append(.image(url: url))
                    }
                }
            } else {
                if let imgs = news?.imageList {
                    for (_, ele) in imgs.enumerated() {
                        if let url = ele.url {
                            cellTypes.append(.image(url: url))
//                            cellTypes.append(.image(url: url))
//                            cellTypes.append(.image(url: url))
                        }
                    }
                }
            }
            cellTypes.append(.content(content: newsDetail?.content))
            tableview.reloadData()
        }
    }
    
    let tableview = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let news = news,
              let id = news.id else {
            return
        }
        view.addSubview(tableview)
        tableview.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        })
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.tableFooterView = UIView()
        tableview.register(UINib(nibName: "NewsImageTableViewCell", bundle: .main), forCellReuseIdentifier: "NewsImageTableViewCell")
        tableview.register(UINib(nibName: "NewsTitleTableViewCell", bundle: .main), forCellReuseIdentifier: "NewsTitleTableViewCell")
        tableview.register(UINib(nibName: "NewsContentTableViewCell", bundle: .main), forCellReuseIdentifier: "NewsContentTableViewCell")
        tableview.estimatedRowHeight = UITableView.automaticDimension
        
        Service.shared.newsDetail(id: id).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.newsDetail = data
                
            default: break
            }
        }.cauterize()
    }
}
/*
 if let imgs = self?.newsDetail?.imageList {
 let w = UIScreen.main.bounds.width - 40
 let height = 1 / 2.4 * (UIScreen.main.bounds.width - 40)
 for (_, ele) in imgs.enumerated() {
 let imgView = UIImageView()
 imgView.contentMode = .scaleAspectFill
 self?.stack.addArrangedSubview(imgView)
 imgView.snp.makeConstraints({ make in
 make.width.equalTo(w)
 make.height.equalTo(height)
 })
 if let url = ele.url {
 imgView.kf.setImage(with: URL.init(string: url))
 }
 }
 }
 */
