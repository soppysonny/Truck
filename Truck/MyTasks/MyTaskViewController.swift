import UIKit

class MyTaskViewController: BaseViewController {
    let segment = UISegmentedControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestData(isConfirmed: true)
    }
    
    func setupUI() {
        
    }
    
    func requestData(isConfirmed: Bool) {
        guard let user = LoginManager.shared.user,
            let roleKey  = user.role.roleKey else { return }
        Service().taskList(userId: user.user.userId, status: isConfirmed ? "0" : "1", roleKey: roleKey).done { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let errorResp):
                print(errorResp.msg, errorResp.code)
            }
        }.catch{ error in
            print(error)
        }
    }
    
}
