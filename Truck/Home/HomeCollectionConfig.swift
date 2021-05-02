import Foundation
import UIKit
extension LoginPost {
    var homeCellTypes: [HomeCellType] {
        switch self.postType {
        case .manager: // 调度员
            return [
                .Statistics,
                .Announce,
                .Notification,
                .Dispatch,
                .More
            ]
        case .siteManager: // 装点管理员
            return [
                .Violation,
                .Statistics,
                .Announce,
                .Notification,
                .More
            ]
        case .driver: // 油罐车
            return [
                .Gas,
                .Violation,
                .Repairing,
                .Statistics,
                .Announce,
                .Notification,
                .More
            ]
        case .truckDriver: // 司机
            return [
                .Gas,
                .Violation,
                .Repairing,
                .Statistics,
                .Announce,
                .Notification,
                .More
            ]
        case .excavateDriver: // 挖机
            return [
                .Gas,
                .Violation,
                .Repairing,
                .Statistics,
                .Announce,
                .Notification,
                .More
            ]
        case .none:
            return []
        }
    }
}

enum HomeCellType {
    case MyTask // 我的任务
    case WorkBench // 工作台
    case Dispatch // 临时调度
    case Gas // 车辆加油
    case Violation // 车辆违章
    case Repairing // 维修上报
    case Statistics // 统计报表
    case Announce // 公告
    case Notification // 通知
    case More // 更多
}

extension HomeCellType {
    var imageName: String {
        switch self {
        case .MyTask:
            return "WDRW"
        case .WorkBench:
            return "GZT"
        case .Dispatch:
            return "LSDD"
        case .Gas:
            return "CLJY"
        case .Violation:
            return "CLWZ"
        case .Repairing:
            return "WXSB"
        case .Statistics:
            return "TJBB"
        case .Announce:
            return "gg"
        case .Notification:
            return "tz"
        case .More:
            return "ic_more"
        }
    }
    
    var title: String {
        switch self {
        case .MyTask:
            return "我的任务"
        case .WorkBench:
            return "工作台"
        case .Dispatch:
            return "临时调度"
        case .Gas:
            return "车辆加油"
        case .Violation:
            return "车辆违章"
        case .Repairing:
            return "维修上报"
        case .Statistics:
            return "统计报表"
        case .Announce:
            return "公告"
        case .Notification:
            return "通知"
        case .More:
            return "更多"
        }
    }
    
    var routeViewController: BaseViewController {
        switch self {
        case .MyTask:
            return MyTaskViewController()
        case .WorkBench:
            return WorkBenchViewController()
        case .Dispatch:
            return DispatchViewController()
        case .Gas:
            return GasViewController()
        case .Violation:
            return ViolationViewController()
        case .Repairing:
            return RepairViewController()
        case .Statistics:
            return StatisticsViewController()
        case .Announce:
            return AnnounceListViewController()
        case .Notification:
            return NotificationListViewController()
        case .More:
            return JSWebViewController(webType: .more)
        }
    }
    
}
