import UIKit
protocol ChangeProfileAlbumTableViewCellProtocol: class {
    func deleteAlbumPhoto(_ indexpath: Int)
    func addAlbumPhoto()
}
class ChangeProfileAlbumTableViewCell: UITableViewCell {
    weak var delegate: ChangeProfileAlbumTableViewCellProtocol?
    let titleLabel = UILabel()
    var collectionView: UICollectionView!
    private var albums: [UploadFileResponse]?
    var imageElements: [ImageListElement]?
    let itemWidth = (UIScreen.main.bounds.width - 15 * 4) / 3.0
    var isEditable = true
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.textColor = UIColor.fontColor_black_153
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.text = "上传照片"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(16.5)
        }
        
        let layout = FilterViewCollectionFlowLayout()
        layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.layer.masksToBounds = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(itemWidth * 3 + 15 * 2)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(AlbumImageCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumImageCollectionViewCell")
        selectionStyle = .none
    }
    
    func configEditable(_ isEditable: Bool) {
        self.isEditable = isEditable
        collectionView.reloadData()
    }
    
    func configAlbums(_ albums: [UploadFileResponse]) {
        self.albums = albums
//        let count = itemCount()
        let lines = 3 //count / 3 + (count % 3 == 0 ? 0 : 1)
        let height = CGFloat(lines) * itemWidth + CGFloat(15 * lines)
        collectionView.snp.remakeConstraints{ make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(height)
            make.bottom.equalToSuperview().offset(-10)
        }
        collectionView.reloadData()
    }
    
    func itemCount() -> Int {
        guard isEditable else {
            return imageElements?.count ?? 0
        }
        guard let albums = albums else {
            return 1
        }
        return albums.count >= 8 ? 9 : albums.count + 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ChangeProfileAlbumTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumImageCollectionViewCell", for: indexPath) as? AlbumImageCollectionViewCell else {
            fatalError()
        }
        
        if isEditable {
            cell.delegate = self
            guard let albums = albums else {
                cell.configType(.add)
                return cell
            }
            let itemNum = itemCount()
            let isLast = itemNum - 1 == indexPath.row
            cell.configType((isLast && albums.count < 9) ? .add : .image(url: URL.init(string: albums[indexPath.row].url ?? ""), placeholderImage: nil))
        } else {
            cell.deleteButton.isHidden = true
            guard let images = imageElements else {
                return cell
            }
            cell.configType(.solidImage(url: URL.init(string: images[indexPath.row].url ?? ""), placeholderImage: nil))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isEditable else {
            return
        }
        let itemNum = itemCount()
        guard let albums = albums else {
            delegate?.addAlbumPhoto()
            return
        }
        let isLast = itemNum - 1 == indexPath.row
        if isLast && albums.count < 9 {
            delegate?.addAlbumPhoto()
        }
    }
}

extension ChangeProfileAlbumTableViewCell: AlbumImageCellProtocol {
    func delete(_ cell: AlbumImageCollectionViewCell) {
        guard let indexpath = collectionView.indexPath(for: cell) else {
            return
        }
        delegate?.deleteAlbumPhoto(indexpath.row)
    }
}

class FilterViewCollectionFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
         let attributes = super.layoutAttributesForElements(in: rect)
         var leftMargin = sectionInset.left
         var maxY: CGFloat = -1.0
         attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }
             if layoutAttribute.frame.origin.y >= maxY {
                 leftMargin = sectionInset.left
             }
             layoutAttribute.frame.origin.x = leftMargin
             leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
             maxY = max(layoutAttribute.frame.maxY , maxY)
         }

         return attributes
     }
}
