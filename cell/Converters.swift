import Foundation

func hourToDateComponent(_ hour: String) -> DateComponents {
    var entered = DateComponents()
    entered.year = 2019
    entered.month = 5
    entered.day = 17
    entered.hour = Int(hour)
    entered.minute = 0
    entered.timeZone = TimeZone.autoupdatingCurrent
    return entered
}

func dateComponentToAbsoluteTime(_ dateComponent: DateComponents) -> Date {
    return Calendar(identifier: .gregorian).date(from: dateComponent)!
}

func absoluteTimeToDateComponent(_ absoluteTime: Date, _ timeZone: TimeZone) -> DateComponents {
    let dateComponent = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: absoluteTime)
    return dateComponent
}

func absoluteTimeToDisplayDay(daysFromToday: Int, absoluteTime: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .ordinal
    let day = numberFormatter.string(from: Calendar.current.component(.day, from: absoluteTime) as NSNumber)!
    
    switch daysFromToday {
    case 0:
        return "Today"
    case 1:
        return "Tomorrow"
    case 2...6:
        return "This " + dateFormatter.string(from: absoluteTime) + " " + day
    case 7...13:
        return "Next " + dateFormatter.string(from: absoluteTime) + " " + day
    default:
        return dateFormatter.string(from: absoluteTime) + " " + day
    }
}

func format(_ dateComponent: DateComponents) -> String {
    let formatted = "\(dateComponent.day!)" + "/" + "\(dateComponent.month!)" + ": " + "\(dateComponent.hour!)" + "\n"
    return formatted
}

func makeMessage(_ absoluteTimes: [Date], _ timeZone: TimeZone) -> String {
    let dateComponents = absoluteTimes.map({ absoluteTime -> DateComponents in
        return absoluteTimeToDateComponent(absoluteTime, timeZone)
    })
    let formatted = dateComponents.map({ dateComponent -> String in
        return format(dateComponent)
    })
    let message = "\(timeZone)" + "\n" + formatted.flatMap{$0}
    return message
}

func summaryFromTimes(_ absoluteTimes: [Date], _ theirTimeZone: TimeZone? = nil) -> String {
    var summary = ""
    let myMessage = makeMessage(absoluteTimes, TimeZone.autoupdatingCurrent)
    summary.append(myMessage)
    if theirTimeZone != nil {
        let theirMessage = makeMessage(absoluteTimes, theirTimeZone!)
        summary.append(theirMessage)
    }
    print(summary)
    return summary
}
