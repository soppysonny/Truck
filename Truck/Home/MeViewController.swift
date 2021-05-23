import Foundation
class MeViewController: BaseViewController {
    let headerImageView = UIImageView()
    let avatarImgView = UIImageView()
    let companyLabel = UILabel()
    let nicknameLabel = UILabel()
    let phoneLabel = UILabel()
    let numberPlateLabel = UILabel()
    
    let container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.addSubview(headerImageView)
        headerImageView.image = UIImage(named: "my_header")
        headerImageView.isUserInteractionEnabled = true
        headerImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(headerTapped)))
        let headerImgHeight = 213 / 375 * UIScreen.main.bounds.width
        headerImageView.snp.makeConstraints({ make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(headerImgHeight)
        })
        view.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints({ make in
            make.width.height.equalTo(60)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(23)
            make.left.equalTo(17)
        })
        avatarImgView.contentMode = .scaleAspectFill
        avatarImgView.borderWidth = 2
        avatarImgView.borderColor = .white
        avatarImgView.cornerRadius = 7
        avatarImgView.image = UIImage(named: "person_header")

        view.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImgView.snp.right).offset(19)
            make.top.equalTo(avatarImgView.snp.top).offset(2)
            make.height.equalTo(14)
        }
        companyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        companyLabel.textColor = .white
        
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints({ make in
            make.height.equalTo(20)
            make.left.equalTo(avatarImgView.snp.right).offset(19)
            make.centerY.equalTo(avatarImgView)
        })
        nicknameLabel.font = .boldSystemFont(ofSize: 19)
        nicknameLabel.textColor = .white
        
        view.addSubview(numberPlateLabel)
        numberPlateLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(nicknameLabel.snp.right)
            make.centerY.equalTo(nicknameLabel)
        }
        numberPlateLabel.font = .systemFont(ofSize: 14)
        numberPlateLabel.textColor = .white
        numberPlateLabel.textAlignment = .left
        
        view.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints({ make in
            make.height.equalTo(15)
            make.left.equalTo(avatarImgView.snp.right).offset(19)
            make.bottom.equalTo(avatarImgView.snp.bottom)
        })
        phoneLabel.font = .systemFont(ofSize: 15)
        phoneLabel.textColor = .white
        
        let arrowImgView = UIImageView()
        view.addSubview(arrowImgView)
        arrowImgView.snp.makeConstraints({ make in
            make.width.height.equalTo(22)
            make.centerY.equalTo(avatarImgView.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        })
        arrowImgView.image = UIImage(named: "my_arrow")
        
        let container = UIView()
        view.addSubview(container)
        container.backgroundColor = .white
        container.snp.makeConstraints({ make in
            make.height.equalTo(100)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(arrowImgView.snp.bottom).offset(32)
        })
        container.layer.cornerRadius = 7
        view.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
        container.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        container.layer.shadowOpacity = 0.05
        container.layer.shadowOffset = CGSize.init(width: 0, height: 1.5)
        container.layer.shadowRadius = 7.5
        
        let view1 = TapCell()
        container.addSubview(view1)
        view1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        view1.imgView.image = UIImage(named: "ic_set_password")
        view1.label.text = "修改密码"
        view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(revisePW)))
        let view2 = TapCell()
        container.addSubview(view2)
        view2.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        view2.imgView.image = UIImage(named: "ic_set_logout")
        view2.label.text = "退出登陆"
        view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logout)))
    }
    
    @objc
    func revisePW() {
        navigationController?.pushViewController(RevisePWViewController(), animated: true)
    }
    @objc
    func logout() {
        LoginManager.shared.logout()
    }
    
    class TapCell: UIView {
        let imgView = UIImageView()
        let label = UILabel()
        let arrow = UIImageView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imgView)
            imgView.contentMode = .scaleAspectFit
            addSubview(label)
            addSubview(arrow)
            arrow.image = UIImage(named: "my_arrow")
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            imgView.snp.remakeConstraints {
                $0.width.height.equalTo(20)
                $0.centerY.equalToSuperview()
                $0.left.equalTo(15)
            }
            label.snp.remakeConstraints {
                $0.left.equalTo(imgView.snp.right).offset(10)
                $0.centerY.equalToSuperview()
            }
            arrow.snp.makeConstraints {
                $0.width.height.equalTo(20)
                $0.right.equalToSuperview().offset(-15)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    @objc
    func headerTapped() {
        let myvc = MyViewController()
        myvc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(myvc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        companyLabel.text = LoginManager.shared.user?.company.alias
        nicknameLabel.text = LoginManager.shared.user?.user.nickName
        phoneLabel.text = LoginManager.shared.user?.user.phonenumber
        let num = LoginManager.shared.user?.vehicle?[safe: 0]?.plateNum
        numberPlateLabel.text = (num == nil || num?.isEmpty == true) ?
            nil :
            "(" + (num ?? "") + ")"
    }
    
}
