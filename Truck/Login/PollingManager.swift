import UIKit

class PollingManager {
    static let shared = PollingManager()
    weak var home: HomeViewController? {
        didSet {
            home?.configNotification(hasUnreadMsg: unreadTime != nil)
        }
    }
    var timer: Timer?
    var readMsgTime: Date? {
        didSet {
            UserDefaults.standard.setValue(readMsgTime?.toString(format: .debug, locale: "zh_CN"), forKey: "readMsgTimeString")
        }
    }
    var unreadTime: Date? {
        didSet {
            UserDefaults.standard.setValue(unreadTime?.toString(format: .debug, locale: "zh_CN"), forKey: "unreadMsgTimeString")
        }
    }
    
    init() {
        if let readMsgTimeString = UserDefaults.standard.value(forKey: "readMsgTimeString") as? String {
            readMsgTime = readMsgTimeString.toDate(format: .debug, locale: "zh_CN")
        } else {
            readMsgTime = Date.now
        }
        if let unreadMsgTimeString = UserDefaults.standard.value(forKey: "unreadMsgTimeString") as? String {
            unreadTime = unreadMsgTimeString.toDate(format: .debug, locale: "zh_CN")
            home?.configNotification(hasUnreadMsg: true)
        }
        guard let readMsgTime = readMsgTime,
              let unreadMsgTime = unreadTime else {
            return
        }
        if readMsgTime.isPassed(since: unreadMsgTime) {
            self.unreadTime = nil
            UserDefaults.standard.setValue(nil, forKey: "unreadMsgTimeString")
        }
    }
    
    func pollingMsgList() {
        let timer = Timer.init(fire: .now, interval: 15, repeats: true, block: { [weak self] _ in
            guard let self = self else {return }
            guard let cid = LoginManager.shared.user?.company.companyId,
                  let readMsgTime = self.readMsgTime else {
                return
            }
            let unreadTime = (self.unreadTime ?? readMsgTime).toString(format: .debug, locale: "zh_CN")
            Service.shared.pollingList(req: PollingListRequest.init(companyId: cid, createTime: unreadTime)).done { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let resp):
                    guard let data = resp.data,
                          let element = data[safe: 0] else {
                        return
                    }
                    if element.hasNewMsg {
                        self.requestNotificationList()
                    }
                case .failure:
                    break
                }
            }.cauterize()
        })
        self.timer = timer
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }
    
    func didRead(time: Date) {
        if let unreadMsgTime = unreadTime {
            if time.isPassed(since: unreadMsgTime) {
                self.unreadTime = nil
                readMsgTime = time
                home?.configNotification(hasUnreadMsg: false)
            } else {
                home?.configNotification(hasUnreadMsg: true)
            }
        } else {
            home?.configNotification(hasUnreadMsg: false)
        }
    }
    
    func checkNewMsg() {
        
    }
    
    func requestNotificationList() {
        guard let cid = LoginManager.shared.user?.company.companyId,
              let postType = LoginManager.shared.user?.post.postType,
              let uid = LoginManager.shared.user?.user.userId else {
            return
        }
        Service.shared.listMsg(req: ListMsgRequest.init(companyId: cid, pageNum: 1, postType: postType.rawValue, userId: uid)).done { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let resp):
                guard let data = resp.data,
                      let element = data[safe: 0],
                      let newdate = element.createTime?.toDate(format: .debug, locale: "zh_CN") else {
                    return
                }
                if let unreadTime = self.unreadTime {
                    if newdate.isPassed(since: unreadTime) {
                        self.unreadTime = newdate
                        // 红点 + 播报
                        self.home?.configNotification(hasUnreadMsg: true)
                        VoicePlaybackManager.playWithType(.newNotification)
                    } else {
                        if let readDate = self.readMsgTime {
                            if newdate.isPassed(since: readDate) {
                                self.home?.configNotification(hasUnreadMsg: true)
                            } else {
                                self.home?.configNotification(hasUnreadMsg: false)
                            }
                        } else {
                            // 理论上不存在有未读消息却不存在已读消息的情况，此处只显示红点
                            self.home?.configNotification(hasUnreadMsg: true)
                        }
                    }
                    
                } else {
                    if let readDate = self.readMsgTime {
                        if newdate.isPassed(since: readDate) {
                            self.unreadTime = newdate
                            self.home?.configNotification(hasUnreadMsg: true)
                            VoicePlaybackManager.playWithType(.newNotification)
                        } else {
                            self.home?.configNotification(hasUnreadMsg: false)
                        }
                    } else {
                        self.unreadTime = newdate
                        self.home?.configNotification(hasUnreadMsg: true)
                        VoicePlaybackManager.playWithType(.newNotification)
                    }
                }
            case .failure:
                break
            }
        }.cauterize()
    }
    
}
