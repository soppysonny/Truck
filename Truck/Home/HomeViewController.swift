import UIKit
import ImageSlideshow
class HomeViewController: BaseViewController {
    let headerImageView = ImageSlideshow()
    var collectionView: UICollectionView!
    var cellTypes = [HomeCellType]()
    
    var hasNewMsg = false
    var newsList: [ListNewsResponse]? {
        didSet {
            var sources = [InputSource]()
            if let newsList = newsList {
                sources = newsList.compactMap {
                    guard let url = $0.imageList?[safe: 0]?.url else {
                        return nil
                    }
                    return KingfisherSource.init(urlString: url)
                }
            }
            headerImageView.setImageInputs(sources)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestUnconfirmedTask()
    }
    func setupUI() {
        title = "首页"
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        view.addSubview(headerImageView)
        let height = 1 / 2.4 * (UIScreen.main.bounds.width - 40)
        headerImageView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(height)
        })
        headerImageView.slideshowInterval = 5.0
        headerImageView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 32))
        headerImageView.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        headerImageView.pageIndicator = pageControl
        headerImageView.pageIndicatorPosition = PageIndicatorPosition.init(horizontal: .center, vertical: .bottom)
        headerImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapSlide)))
        
        let blueBar = UIView()
        view.addSubview(blueBar)
        blueBar.snp.makeConstraints({ make in
            make.width.equalTo(3)
            make.height.equalTo(15)
            make.left.equalTo(headerImageView)
            make.top.equalTo(headerImageView.snp.bottom).offset(22.5)
        })
        blueBar.backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.6352941176, blue: 0.9568627451, alpha: 1)
        let functionLabel = UILabel()
        functionLabel.textAlignment = .left
        functionLabel.font = .systemFont(ofSize: 12, weight: .bold)
        functionLabel.text = "功能列表"
        functionLabel.textColor = .black
        view.addSubview(functionLabel)
        functionLabel.snp.makeConstraints{ make in
            make.left.equalTo(blueBar.snp.right).offset(5)
            make.centerY.equalTo(blueBar)
            make.height.equalTo(15)
        }
        let layout = UICollectionViewFlowLayout()
        let itemSize = (UIScreen.main.bounds.size.width - 20 * 2 - 17 * 2) / 3.0 - 0.5
        layout.itemSize = CGSize.init(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = 17
        layout.minimumInteritemSpacing = 17
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints({ make in
            make.top.equalTo(blueBar.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        collectionView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        collectionView.register(UINib.init(nibName: "HomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupLayout()
        requestNews()
        PollingManager.shared.home = self
        PollingManager.shared.pollingMsgList()
    }
    
    func requestUnconfirmedTask() {
        guard let user = LoginManager.shared.user,
              let postType = user.post.postType else {
            return
        }
        Service().taskList(userId: user.user.userId,
                           status: 0,
                           postType: postType.rawValue,
                           pageNum: 0).done { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
                guard let rows = response.data else {
                    return
                }
                if !rows.isEmpty {
                    let vc = TaskDetailViewController.init(nibName: "TaskDetailViewController", bundle: .main)
                    vc.task = rows[0]
                    let nav = UINavigationController.init(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalTransitionStyle = .coverVertical
                    self?.present(nav, animated: true, completion: nil)
                }
            default: break
            }
        }.catch{ error in
            print(error)
            
        }
    }
    
    func configNotification(hasUnreadMsg: Bool) {
        hasNewMsg = hasUnreadMsg
        collectionView.reloadData()
    }
    
    func requestNews(){
        guard let cid = LoginManager.shared.user?.company.companyId else {
            return
        }
        Service.shared.listNews(req: ListNewsRequests.init(companyId: cid)).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let list = resp.data else {
                    return
                }
                self?.newsList = list
            case .failure(let err):
                self?.view.makeToast(err.msg)
            }
        }.catch{ [weak self] error in
            self?.view.makeToast(error.localizedDescription)
        }
    }
    
    @objc
    func tapSlide() {
        let index = headerImageView.currentPage
        guard let news = newsList?[safe: index] else {
            return
        }
        let newsvc = NewsDetailViewController()
        newsvc.news = news
        newsvc.title = "新闻详情"
        navigationController?.pushViewController(newsvc, animated: true)
    }
    
    @objc
    func routeToUserPage() {
        navigationController?.pushViewController(MyViewController(), animated: true)
    }
    
    func setupLayout() {
        guard let user = LoginManager.shared.user else {
            return
        }
        cellTypes = user.post.homeCellTypes
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.cornerRadius = 10
        cell.shadowColor = .black
        cell.shadowOpacity = 0.1
        cell.shadowRadius = 9
        
        cell.imageView.image = UIImage.init(named: cellTypes[indexPath.row].imageName)
        cell.label.text = cellTypes[indexPath.row].title
        cell.dot.isHidden =  !(cellTypes[indexPath.row] == .Notification && hasNewMsg)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celltype = cellTypes[indexPath.row]
        navigationController?.pushViewController(celltype.routeViewController, animated: true)
    }
}
