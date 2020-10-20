import UIKit

class OrderOperateViewController: BaseViewController {
    var type: OrderDetailBottomButtonType = .applyForTransfer
    init(type: OrderDetailBottomButtonType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
