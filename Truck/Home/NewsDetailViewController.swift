import UIKit

class NewsDetailViewController: BaseViewController {
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    var news: ListNewsResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新闻详情"
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
        
        titleLabel.text = news?.title
        contentTextView.text = news?.content
        
        
    }
}
