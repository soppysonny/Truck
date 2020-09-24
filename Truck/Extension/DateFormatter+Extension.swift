import Foundation
enum DateLocale {
    case au
    case cn
}

extension DateFormatter {
    class func defaultFormatter(dateFormat: String, locale: String, timeZone: TimeZone? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: locale)
        formatter.timeZone = timeZone ?? TimeZone.current
        formatter.dateFormat = dateFormat
        return formatter
    }
    
}
