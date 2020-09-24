import Foundation

extension Dictionary {
    /** 複数のdictionaryを統合する。同じキーがあった場合は後に指定したやつで更新される。 */
    public func union(_ dictionaries: Dictionary...) -> Dictionary {

        var result = self

        dictionaries.forEach { dictionary in
            dictionary.forEach { key, value in
                _ = result.updateValue(value, forKey: key)
            }
        }

        return result
    }
}
