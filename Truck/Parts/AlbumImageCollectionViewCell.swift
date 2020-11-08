import UIKit
import Kingfisher
enum AlbumItemType {
    case add
    case image(url: URL?, placeholderImage: UIImage?)
    case solidImage(url: URL?, placeholderImage: UIImage?)
}

protocol AlbumImageCellProtocol: class {    
    func delete(_ cell: AlbumImageCollectionViewCell)
}

class AlbumImageCollectionViewCell: UICollectionViewCell {
    let imgView = UIImageView()
    let deleteButton = UIButton()
    var type: AlbumItemType?
    weak var delegate: AlbumImageCellProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imgView)
        imgView.backgroundColor = .lightGray
        imgView.snp.makeConstraints{ make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        imgView.contentMode = .scaleAspectFill
        imgView.cornerRadius = 10
        
        contentView.addSubview(deleteButton)
        deleteButton.setImage(UIImage.init(named: "delete_image"), for: .normal)
        deleteButton.snp.makeConstraints({ make in
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        })
        deleteButton.addTarget(self, action: #selector(deleteSelector), for: .touchUpInside)
    }
    
    @objc
    func deleteSelector() {
        delegate?.delete(self)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configType(_ type: AlbumItemType) {
        self.type = type
        switch type {
        case .add:
            imgView.image = UIImage.init(named: "add_image")
            imgView.backgroundColor = .white
            deleteButton.isHidden = true
            break
        case .image(let url, let placeholderImage):
            imgView.backgroundColor = .lightGray
            imgView.kf.setImage(with: url, placeholder: placeholderImage)
            deleteButton.isHidden = false
            break
        case .solidImage(let url, let placeholderImage):
            imgView.backgroundColor = .lightGray
            imgView.kf.setImage(with: url, placeholder: placeholderImage)
            deleteButton.isHidden = true
            break
        }
    }
}
