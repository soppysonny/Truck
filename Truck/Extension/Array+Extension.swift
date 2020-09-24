import Foundation

extension Array {
    public func chunked(_ chunkSize: Int, fillWith:(() -> Element)? = nil) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            let end = self.endIndex
            let chunkEnd = self.index($0, offsetBy: chunkSize, limitedBy: end) ?? end
            let num = chunkEnd - $0
            if let fillWith = fillWith, chunkSize > num {
                return Array(self[$0..<chunkEnd]) + (num..<chunkSize).map { _ in fillWith() }
            } else {
                return Array(self[$0..<chunkEnd])
            }
        }
    }

    public func grouped<Key: Hashable>(function: (Element) -> Key) -> [Key: [Element]] {
        return self.reduce([:]) {(prev: [Key: [Element]], item: Element) -> [Key: [Element]] in
            let key = function(item)
            var ret = prev

            if var arr = ret[key] {
                arr.append(item)
                ret.updateValue(arr, forKey: key)
            } else {
                ret[key] = [item]
            }
            return ret
        }
    }

    public mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let dist: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: dist)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Array where Element: Hashable {

    public func unique() -> [Element] {
        var elms: [Element] = []
        var set: Set<Element> = []
        for item in self {
            if set.insert(item).inserted {
                elms.append(item)
            }
        }
        return elms
    }

}

extension Array where Element: Equatable {

    public func removed(_ element: Element) -> [Element] {
        return self.filter { $0 != element }
    }

    public func removed(_ elements: [Element]) -> [Element] {
        return self.filter { !elements.contains($0) }
    }

    //戻り値は(要素,追加ならtrue)のtuple
    public func addedOrRemoved(_ element: Element) -> ([Element], Bool) {
        return contains(element) ? (removed(element), false) : (self + [element], true)
    }
}

extension Array where Element == String {
    /// 配列の中身があれば、joinします。
    /// 空の場合には、nilを返します。
    public func joinedOrNil(separator: String) -> String? {
        guard self.count > 0 else { return nil }
        return self.joined(separator: separator)
    }
}
