import Foundation

public var nowCls = { Date() }

extension Date {
    public func toString(format: DateFormat, locale: String, timeZone: TimeZone? = nil) -> String {
        let formatter = DateFormatter.defaultFormatter(dateFormat: format.rawValue, locale: locale, timeZone: timeZone)
        return formatter.string(from: self)
    }

    public func differenceHour(_ date: Date) -> Int {
        let interval = timeIntervalSince(date)
        let differenceHour = Int(ceil(interval / (60 * 60)))
        return differenceHour
    }

    public func differenceDay(_ date: Date) -> Int {
        let diffDay = Float(differenceHour(date)) / 24
        return Int(ceilf(diffDay))
    }

    public func calcDate(day: Int) -> Date {
        let time = day * (24 * 60 * 60)
        return Date(timeIntervalSinceNow: TimeInterval(time))
    }

    public func added(year: Int? = nil, month: Int? = nil, day: Int? = nil,
                      hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil) -> Date {

        let comps = DateComponents(year: year, month: month, day: day,
                                   hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        return Calendar.current.date(byAdding: comps, to: self) ?? Date.now //後ろはありえないけどクラッシュ回避
    }

    public var timeRemoved: Date {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comps) ?? Date.now //後ろはありえないけどクラッシュ回避
    }

    public static var now: Date {
        return nowCls()
    }
    var weekBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: sameTime)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: sameTime)!
    }
    
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: sameTime)!
    }
    
    var lastSecondOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }

    var sameTime: Date {
        return Calendar.current.date(bySettingHour: hour(), minute: minute(), second: second(), of: self)!
    }
    
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    public static func setNow(_ updatingCls:@escaping () -> Date) {
        nowCls = updatingCls
    }

    public func isSameDay(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

    public func isPassed(since sinceDate: Date) -> Bool {
        let interval = self.timeIntervalSince(sinceDate)
        return interval >= 0
    }

    /// 時間をTimeIntervalに変換します
    public static func hourToTimeInterval(_ hour: Double) -> TimeInterval {
        return TimeInterval(60 * 60 * hour)
    }
}

extension Date {

    private static let components: Set<Calendar.Component> =
        [.era, .year, .month, .day, .hour, .minute, .second,
         .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear,
         .nanosecond, .calendar, .timeZone]

    private func dateComponents() -> DateComponents {
        return Calendar.current.dateComponents(Date.components, from: self)
    }

    public func hour() -> Int {
        return dateComponents().hour ?? 0
    }

    public func minute() -> Int {
        return dateComponents().minute ?? 0
    }
    
    public func second() -> Int {
        return dateComponents().second ?? 0
    }

    public var year: Int {
        return dateComponents().year ?? 0
    }

    public var month: Int {
        return dateComponents().month ?? 0
    }

    public var day: Int {
        return dateComponents().day ?? 0
    }
    
    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
}
