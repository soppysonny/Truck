import UIKit
import AMapFoundationKit
class MapTableViewCell: UITableViewCell, MAMapViewDelegate {
    let mapView = MAMapView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        mapView.delegate = self
        contentView.addSubview(mapView)
        mapView.snp.makeConstraints({ make in
            make.edges.equalTo(UIEdgeInsets.zero)
            make.height.equalTo(UIScreen.main.bounds.width / 16.0 * 9)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if let pinview = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")  {
            if let title = annotation.title as? String {
                pinview.setImage(imageName: title)
            }
            return pinview
        } else {
            if let pinview = MAAnnotationView.init(annotation: annotation, reuseIdentifier:"pin") {
                if let title = annotation.title as? String {
                    pinview.setImage(imageName: title)
                }
                return pinview
            } else {
                return MAAnnotationView()
            }
        }
    }
    
    
}
