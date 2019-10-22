import Foundation

protocol ModelDelegate: class {
    func timesUpdated(_ times: [Date])
}

protocol CellsModelDelegate: class {
    func hoursUpdated(_ hours: [Int])
    func daysUpdated(_ days: [Date])
}

class Model {
    
    weak var delegate: ModelDelegate?
    
    var absoluteTimes = [Date]()
    var theirTimeZone: TimeZone?
    
    func addATime(_ time: Date) {
        absoluteTimes.append(time)
        absoluteTimes.sort()
        delegate?.timesUpdated(absoluteTimes)
    }
    
    func removeATime(_ time: Date) {
        absoluteTimes = absoluteTimes.filter{$0 != time}
        delegate?.timesUpdated(absoluteTimes)
    }
    
    func updateTheirTimeZone(_ timeZone: TimeZone) {
        theirTimeZone = timeZone
        delegate?.timesUpdated(absoluteTimes)
    }
    
}

class CellsModel {
    
    weak var delegate: CellsModelDelegate?
    
    var hoursShown = [Int]()
    var daysShown = [Date]()

    func updateHoursShown(fromHour: Int, toHour: Int) {
        hoursShown = Array(fromHour...toHour)
        delegate?.hoursUpdated(hoursShown)
    }
    
    func makeDaysShown(numberOfDays: Int) {
        let daysFromNow = Array(0...numberOfDays-1)
        daysShown = daysFromNow.map({ daysToAdd -> Date in
            return Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())!
        })
        delegate?.daysUpdated(daysShown)
    }
    
    init() {
        updateHoursShown(fromHour: 8, toHour: 22)
        makeDaysShown(numberOfDays: 7)
    }
}

class SummaryModel {
    
    var summary: String!
    
    func getSummary() -> String {
        return ""
    }
    
}
