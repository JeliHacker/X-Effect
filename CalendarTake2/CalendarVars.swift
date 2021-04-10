
import Foundation


let date = Date()
let calendar = Calendar.current
let currentCalendar = Calendar.current
let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
let currentMonthInt = calendar.component(.month, from: date) - 1
let currentYearInt = calendar.component(.year, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

func printVars() -> Void{
    print("day = " + String(day))
    print("weekday = " + String(weekday))
    print("month = " + String(month))
    print("year = " + String(year))
}

func isALeapYear(year: Int) -> Bool {
    if year % 4 != 0 {
        return false
    } else if year % 100 != 0 {
        return true
    } else if year % 400 != 0 {
        return false
    } else {
        return true
    }
}

