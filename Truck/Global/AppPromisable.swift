import Foundation
import PromiseKit

//Promisekit内にPromisableがあるけど、Generic対応イマイチなので独自定義
public protocol AppPromisable {

    associatedtype PromiseValueType

    var promise: Promise<PromiseValueType> { get }

}

protocol ModalPromisable: AppPromisable {
    func showModal(from viewController: UIViewController, presentingCompletion: (() -> Void)?)
}
