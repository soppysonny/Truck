import UIKit
import PromiseKit
class UploadTool {
    static func uploadImage(image: UIImage)  -> Promise<UploadFileResponse> {
        guard let data = image.jpegData(compressionQuality: 0.75) else {
            let (promise, resolver) = Promise<UploadFileResponse>.pending()
            resolver.reject(Errors.imageDataBroken)
            return promise
        }
        let fileName = Date().toString(format: .numberOnly, locale: "zh_CN") + ".jpg"
        return UploadTool.uploadImage(imageData: data, fileName: fileName, name: "file", mimeType: "image/jpeg")
    }
    
    static func uploadImage(imageData: Data, fileName: String, name: String, mimeType: String) -> Promise<UploadFileResponse> {
        let (promise, resolver) = Promise<UploadFileResponse>.pending()
        Service.shared.fileUplaod(data: imageData, fileName: fileName, name: name, mimeType: mimeType).done { result in
            switch result {
            case .success(let resp):
                resolver.fulfill(resp)
            case .failure(let error):
                resolver.reject(Errors.requestError(message: error.msg, code: error.code))
            }
        }.catch { error in
            resolver.reject(error)
        }
        return promise
    }
}
