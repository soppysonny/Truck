import UIKit

class AnnounceDetailViewController: BaseViewController {
    let titleLabel = UILabel()
    let contentTextView = UITextView()
    var announce: ListNoticeResponse?
    var announceDetail: AnnounceDetailResponse?
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
        
        guard let announce = announce else {
            return
        }
        
        titleLabel.text = announce.title
        contentTextView.text = announce.content
        guard let id = announce.id else {
            return
        }
        Service.shared.noticeDetail(id: id).done { [weak self] result in
            switch result {
            case .success(let resp):
                guard let data = resp.data else {
                    return
                }
                self?.announceDetail = data
                self?.titleLabel.text = data.title
                self?.contentTextView.text = data.content
            default: break
            }
        }.cauterize()
        
    }

}
