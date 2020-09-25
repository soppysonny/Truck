import Foundation

func getNotNil(_ dictionary: [String: Any?]) -> [String: Any] {
    var result: [String: Any] = [:]
    for (key, value) in dictionary {
        guard let checkedValue = value else { continue }
        result[key] = checkedValue
    }
    return result
}

let baseHeader = [
"Content-Type": "application/json",
    "Accept": "application/json"
]

func tokenHeader(token: String) -> [String: String]{
    return  [
    "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": token
    ]
}
 
