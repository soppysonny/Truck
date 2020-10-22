import UIKit

class NewsDetailViewController: BaseViewController {
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    var news: ListNewsResponse?
    var newsDetail: NewsDetailResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        })

        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        contentTextView.isEditable = false
        
        guard let news = news else {
            return
        }
        
        titleLabel.text = news.title
        contentTextView.text = news.content
        guard let id = news.id else {
            return
        }
        Service.shared.newsDetail(id: id).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.newsDetail = data
                self?.titleLabel.text = data.title
                self?.contentTextView.text = data.content
            default: break
            }
        }.cauterize()
    }
}
