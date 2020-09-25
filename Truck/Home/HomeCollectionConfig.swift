import Foundation
import UIKit
extension LoginRole {
    var homeCellTypes: [HomeCellType] {
        switch self.roleId {
        case "1":
            return [
                .MyTask,
                .WorkBench,
                .Dispatch,
                .Gas,
                .Violation,
                .Repairing,
                .Statistics
            ]
        default:
            return [
                .MyTask,
                .WorkBench,
                .Dispatch,
                .Gas,
                .Violation,
                .Repairing,
                .Statistics
            ]
        }
    }
}

enum HomeCellType {
    case MyTask
    case WorkBench
    case Dispatch
    case Gas
    case Violation
    case Repairing
    case Statistics
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
        }
    }
    
}
