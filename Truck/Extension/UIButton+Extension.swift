import UIKit

extension UIButton {
    
    func setHorizontalGradient(from startColor: UIColor, to endColor: UIColor, cornerRadius: CGFloat, frame: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0), NSNumber.init(value: 1)]
        gradientLayer.cornerRadius = cornerRadius
    }
}
