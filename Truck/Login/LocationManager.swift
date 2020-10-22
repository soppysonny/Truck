import UIKit
import AMapLocationKit
import AVFoundation

enum JudgeLocationResultType: String, Codable {
    case notArrived = "0"
    case arrivedAtLoadingPoint = "1"
    case noTask = "2"
    case taskProcessing_3 = "3"
    case taskProcessing_4 = "4"
    case arrivedAtUnloadingPoint = "5"
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    let locationManager = AMapLocationManager.init()
    var locationDidUpdateClosure: ((Double, Double)->())?
    var currentLocation: CLLocation?
    var timer: Timer?
    
    func setup() {
        AMapServices.shared()?.apiKey = "b41bce35c4c636191317fbe07e7de013"
        locationManager.distanceFilter = 10
        locationManager.delegate = self
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startPolling() {
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
              let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        guard let location = currentLocation else {
            return
        }
        Service.shared.judgeLocation(req: JudgeLocationRequest.init(companyId: cid, lat: location.coordinate.latitude, lng: location.coordinate.longitude, projectId: nil, userId: uid)).done{ [weak self] result in
            switch result {
            case .success(let resp):
                guard let element = resp.data else {
                    return
                }
                self?.didGetPollingResult(element.resultType)
            case .failure(let err):
                UIApplication.shared.keyWindow?.makeToast(err.msg)
            }
        }.catch { error in
            UIApplication.shared.keyWindow?.makeToast(error.localizedDescription)
        }
    }
    
    func didGetPollingResult(_ result: JudgeLocationResultType) {
        switch result {
        case .arrivedAtLoadingPoint:
            VoicePlaybackManager.playWithType(.loadPoint)
        case .arrivedAtUnloadingPoint:
            VoicePlaybackManager.playWithType(.unloadPoint)
        default:
            break
        }
    }
    
}


extension LocationManager: AMapLocationManagerDelegate {
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        currentLocation = location
        guard let closure = locationDidUpdateClosure else {
            return
        }
        closure(location.coordinate.longitude, location.coordinate.longitude)
    }
}
