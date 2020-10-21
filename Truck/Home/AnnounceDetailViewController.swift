import UIKit

class AnnounceDetailViewController: BaseViewController {
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    var announce: ListNoticeResponse?

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
        
        titleLabel.text = announce?.title
        contentTextView.text = announce?.content
        
    }

}
