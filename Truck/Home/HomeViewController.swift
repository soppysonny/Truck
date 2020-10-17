import UIKit

class HomeViewController: BaseViewController {
    let headerImageView = UIImageView()
    var collectionView: UICollectionView!
    var cellTypes = [HomeCellType]()
    let userButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        title = "首页"
        view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        view.addSubview(headerImageView)
        let height = 26 / 67.0 * (UIScreen.main.bounds.width - 40)
        headerImageView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(height)
        })
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.image = #imageLiteral(resourceName: "banner")
        
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
        
        userButton.setImage(UIImage.init(named: "user"), for: .normal)
        userButton.addTarget(self, action: #selector(routeToUserPage), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: userButton)
        userButton.snp.makeConstraints({ make in
            make.width.height.equalTo(30)
        })
        setupLayout()
    }
    
    @objc
    func routeToUserPage() {
        
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
        cell.dot.isHidden = indexPath.row % 2 == 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let celltype = cellTypes[indexPath.row]
        navigationController?.pushViewController(celltype.routeViewController, animated: true)
//        Service().uploadImage(image: #imageLiteral(resourceName: "banner")).done { result in
//            switch result {
//            case .success(let resp):
//                print("upload resp: ",resp)
//            case .failure(let error):
//                print("upload error: ",error)
//            }
//        }.catch { error in
//            print("upload catch error: ",error)
//        }
    }
}
