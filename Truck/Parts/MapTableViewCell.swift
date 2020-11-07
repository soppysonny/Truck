import UIKit
import AMapFoundationKit
class MapTableViewCell: UITableViewCell {
    let mapView = MAMapView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
            make.height.equalTo(UIScreen.main.bounds.width / 16.0 * 9)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
