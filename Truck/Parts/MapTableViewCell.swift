import UIKit

class MapTableViewCell: UITableViewCell, BMKMapViewDelegate {
    let mapView = BMKMapView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        mapView.delegate = LocationManager.shared
        mapView.zoomLevel = 12
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
            make.height.equalTo(UIScreen.main.bounds.width / 16.0 * 9)
        })
        mapView.showMapScaleBar = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 

}
