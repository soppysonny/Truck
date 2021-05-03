import UIKit
import AVFoundation

enum JudgeLocationResultType: String, Codable {
    case notArrived = "0"
    case arrivedAtLoadingPoint = "1"
    case noTask = "2"
    case taskProcessing_3 = "3"
    case taskProcessing_4 = "4"
    case arrivedAtUnloadingPoint = "5"
    
}

class LocationManager: NSObject, BMKGeneralDelegate, BMKLocationManagerDelegate {
    static let shared = LocationManager()
    let mapManager = BMKMapManager()
    let locationManager = BMKLocationManager()
    var locationDidUpdateClosure: ((Double, Double)->())?
    var currentLocation: CLLocation?
    var timer: Timer?
    
    func setup() {
        locationManager.delegate = self
        locationManager.coordinateType = .BMK09LL
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.distanceFilter = 10
        guard mapManager.start(kBaiduMapKey, generalDelegate: self) else {
            print("启动百度地图sdk失败")
            return
        }
    }

    func startUpdatingLocation() {
        locationManager.locatingWithReGeocode = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startPolling() {
        if timer != nil {
            timer?.invalidate()
        }
        let timer = Timer.init(fire: .now, interval: 15, repeats: true, block: { [weak self] _ in
            self?.judgeLocationPolling()
        })
        self.timer = timer
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }
    
    @objc
    func judgeLocationPolling() {
        guard let cid = LoginManager.shared.user?.company.companyId,
              let uid = LoginManager.shared.user?.user.userId,
              let postType = LoginManager.shared.user?.post.postType,
              postType == .truckDriver else {
            return
        }
        guard let location = currentLocation else {
            return
        }
        Service.shared.judgeLocation(req: JudgeLocationRequest.init(companyId: cid,
                                                                    lat: location.coordinate.latitude,
                                                                    lng: location.coordinate.longitude,
                                                                    projectId: nil,
                                                                    userId: uid))
            .done{ [weak self] result in
                switch result {
                case .success(let resp):
                    guard let element = resp.data,
                          let resType = element.resultType else {
                        return
                    }
                    self?.didGetPollingResult(resType)
                case .failure(let err):
                    UIApplication.shared.keyWindow?.makeToast(err.msg ?? "")
                }
            }.catch { error in
                UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
            }
    }
    
    func didGetPollingResult(_ result: String) {
        switch result {
        case "1":
            VoicePlaybackManager.playWithType(.loadPoint)
        case "5":
            VoicePlaybackManager.playWithType(.unloadPoint)
        default:
            break
        }
    }
    
    // iError 错误号
    func onGetNetworkState(_ iError: Int32) {
        
    }

    /**
     *返回授权验证错误
     *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
     */
    func onGetPermissionState(_ iError: Int32) {
        
    }
    
    func bmkLocationManagerDidChangeAuthorization(_ manager: BMKLocationManager) {
        
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        guard let newLocation = location?.location else {
            return
        }
        currentLocation = newLocation
        locationDidUpdateClosure?(newLocation.coordinate.longitude, newLocation.coordinate.longitude)
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didChange status: CLAuthorizationStatus) {
        
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, doRequestAlwaysAuthorization locationManager: CLLocationManager) {
        
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate state: BMKLocationNetworkState, orError error: Error?) {
        
    }
    
}

//extension LocationManager: AMapLocationManagerDelegate {
//    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
//        currentLocation = location
//        guard let closure = locationDidUpdateClosure else {
//            return
//        }
//        closure(location.coordinate.longitude, location.coordinate.longitude)
//    }
//}

extension LocationManager: BMKMapViewDelegate {
    
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        print("mapViewDidFinishLoading")
    }
    
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if let pinview = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")  {
            if let title = annotation.title?() {
                pinview.image = UIImage(named: title)
            }
            return pinview
        } else {
            if let pinview = BMKAnnotationView.init(annotation: annotation, reuseIdentifier:"pin") {
                if let title = annotation.title?() {
                    pinview.image = UIImage(named: title)
                }
                return pinview
            } else {
                fatalError()
            }
        }
    }
}
