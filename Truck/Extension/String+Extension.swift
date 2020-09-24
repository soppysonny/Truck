import UIKit

public enum DateFormat: String {
    case debug                     = "yyyy-MM-dd HH:mm:ss"
    case numberOnly                 = "yyyyMMddHHmmss"
    case dateSlash                  = "yyyy/MM/dd"
    case dateSlashAndWeek           = "yyyy/M/d (E)"
    case monthDayOnly               = "M/d"
    case ymd                        = "yyyyMMdd"
    case siteCata                   = "HH:mm-EEEE"
    case timeStamp                  = "yyyy/MM/dd HH:mm:ss"
    case pointHistoryTimeStamp      = "yyyy/MM/dd HH:mm"
    case scheduleDate               = "M/dd（E）"
    case schedule                   = "M/dd（E）HH:mm"
    case hourMinutesOnly            = "HH:mm"
    case chinese                    = "yyyy年MM月dd日"
    case longSchedule               = "yyyy/M/d（E）HH:mm"
    case facebookDate               = "MM/dd/yyyy"
    case webApi                     = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case monthDayWeek               = "M/d（E）"
    case monthDayTime               = "M/d HH:mm"
}

public enum ForbiddenChars: String {
    case selfIntroduction = "\u{25a0}|\u{25a1}|\u{25c6}|\u{25c7}|\u{25cb}|\u{25ce}|\u{25cf}" // ■□◆◇○◎●
}

public extension String {

    func modifyFontColor(text: String, targetText: String, textColor: UIColor) -> NSAttributedString {
        guard let range = text.range(of: targetText) else {
            fatalError("text not found")
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor,
                                      value: textColor,
                                      range: text.nsRange(from: range))
        return attributedString
    }

    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    var isNotEmpty: Bool {
        return !self.isEmpty
    }

    func toDate(format: DateFormat, locale: String) -> Date? {
        let dateFormatter = DateFormatter.defaultFormatter(dateFormat: format.rawValue, locale: locale)
        return dateFormatter.date(from: self)
    }

    @available(*, deprecated, renamed: "nsRanges(of:options:locale:)")
    func getTextRangeList(text: String) -> [NSRange] {
        var rangeList: [NSRange] = []
        while true {
            let range = rangeList.last ?? NSRange(location: 0, length: 0)
            let location = range.location + range.length
            let leftRange = Range<String.Index>(NSRange(location: location, length: self.count - location), in: self)
            guard let tmp = self.range(of: text, options: .literal, range: leftRange, locale: nil) else { break }
            rangeList.append(NSRange(location: tmp.lowerBound.encodedOffset, length: text.count))
        }
        return rangeList
    }

    func ranges(of searchString: String, options mask: NSString.CompareOptions = [],
                       locale: Locale? = nil) -> [Range<String.Index>] {

        var ranges: [Range<String.Index>] = []
        while let range = range(of: searchString, options: mask,
                                range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
                                    ranges.append(range)
        }
        return ranges
    }

    func nsRanges(of searchString: String, options mask: NSString.CompareOptions = [],
                         locale: Locale? = nil) -> [NSRange] {

        let ranges = self.ranges(of: searchString, options: mask, locale: locale)
        return ranges.map { nsRange(from: $0) }
    }

    func hasInvalidChar(_ text: String) -> Bool {
        // FormValidatorに置き換えた方が良い(#1693)
        let pattern = ForbiddenChars.selfIntroduction.rawValue
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let match = regex.numberOfMatches(in: text,
                                              options: .reportCompletion,
                                              range: NSRange(location: 0, length: text.count))

            if match > 0 {
                return true
            }
        } catch {
            fatalError("failure of regex generation: \(pattern)")
        }
        return false
    }

}

// MARK: - Nil or Empty

public protocol StringOptionalProtocol {}

extension String: StringOptionalProtocol {}

public extension Optional where Wrapped: StringOptionalProtocol {

    /// nilまたは空文字の場合はtrueを返す
    var isNilOrEmpty: Bool {
        if let str = self as? String {
            return str.isEmpty
        }
        return true
    }

    /// nilまたは空文字の場合はfalseを返す
    var isNotNilOrNotEmpty: Bool {
        return !isNilOrEmpty
    }
}

// MARk: Trimming

public extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func contains(_ find: String) -> Bool {
        return self.range(of: find) != nil
    }

    func containsIgnoringCase(_ find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

public extension Optional where Wrapped == String {
    func trimmed() -> String? {
        guard let strongSelf = self else { return nil }
        return strongSelf.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

public extension String {
    func attributedTextCommonSpacing(textColor: UIColor,
                                            spacing: CGFloat = 8,
                                            alignment: NSTextAlignment = .left,
                                            lineHeightMultiple: CGFloat? = nil,
                                            font: UIFont = UIFont.systemFont(ofSize: 14)) -> NSMutableAttributedString {
        let lineSpaceStyle = NSMutableParagraphStyle()
        lineSpaceStyle.lineSpacing = spacing
        if let height = lineHeightMultiple {
            lineSpaceStyle.lineHeightMultiple = height
        }
        lineSpaceStyle.alignment = alignment
        let attributed = [NSAttributedString.Key.paragraphStyle: lineSpaceStyle,
                          NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.font: font]
        return NSMutableAttributedString(string: self,
                                         attributes: attributed)
    }
}
