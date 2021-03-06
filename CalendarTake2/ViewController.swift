

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    //Core Data starts now

    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var habitText: UITextField!
    @IBOutlet weak var streakLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var randomDate = Date.init()
    
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let DaysOfMonth = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    var NumberOfEmptyBox = Int()
    var NextNumberOfEmptyBox = Int()
    var PreviousNumberOfEmptyBox = Int()
    var Direction = 0 // 0 at current month, -1 for past month, 1 for future month
    var PositionIndex = 0
    var currentStreak: Int = 0;
    var completedDays: [[Int]] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dateRangeMin = DateComponents()
        dateRangeMin.year = 1980
        
        var dateRangeMax = DateComponents()
        dateRangeMax.year = 1981
        
        print(randomDate)
        
        habitText.delegate = self
        
        currentMonth = Months[month]
        
        MonthLabel.text = "\(currentMonth) \(year)"
        
        GetStartDateDayPosition()
        
        Calendar.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        Calendar.layer.borderWidth = 1
        
        //Looks for single or multiple taps.
         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        habitText.resignFirstResponder()
        return true
    }
    

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func pushDate(stack: [[Int]], date: [Int]) -> [[Int]] {
        var count = 0
        var newArray: [[Int]] = []
        var dateAdded = false
        for stackDate in stack {
            if (isDateBeforeDate(date1: date, date2: stackDate) && !dateAdded) {
                newArray.append(date)
                dateAdded = true
            }
            newArray.append(stackDate)
            count += 1
            //print("newArray: \(newArray)")
        }
        if (!dateAdded) {
            newArray.append(date)
        }
        return newArray
    }
    
    func determineCurrentStreak() -> Int {
        return 1
    }
    
    func isDateBeforeDate(date1: [Int], date2: [Int]) -> Bool { // return true if date1 is before date2, false otherwise
        let yearValueD1 = date1[0] * 100
        let yearValueD2 = date2[0] * 100
        let monthValueD1 = date1[1] * 10
        let monthValueD2 = date2[1] * 10
        let totalValueD1 = yearValueD1 + monthValueD1 + date1[2]
        let totalValueD2 = yearValueD2 + monthValueD2 + date2[2]
        
        if totalValueD1 < totalValueD2 {
            return true
        } else {
            return false
        }
    }
    // MARK: - Next and Back
    @IBAction func Next(_ sender: UIButton) {
        
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            Direction = 1
            
            if isALeapYear(year: year) {
                print("\(year) is a leap year")
                DaysInMonths[1] = 29
            } else {
                DaysInMonths[1] = 28
                print("\(year) is not a leap year")
            }
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        default:
            
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
        if currentMonthInt == month && currentYearInt == year {
            nextButton.isHidden = true
        }
    }
    
    
    @IBAction func Back(_ sender: Any) {
        nextButton.isHidden = false
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            print("\(year) is a leap year: \(isALeapYear(year: year))")
            GetStartDateDayPosition()
            
            if isALeapYear(year: year) {
                DaysInMonths[1] = 29
                print("\(year) is a leap year")
            } else {
                DaysInMonths[1] = 28
                print("\(year) is not a leap year")
            }
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    func GetStartDateDayPosition() {
        print("GetStartDateDayPosition called")
        switch Direction {
        case 0:
            print("case = 0")
            print("weekday = \(weekday)")
            print("day = \(day)")
            switch day{
            case 1...7:
                NumberOfEmptyBox = weekday - day
                print("case 1-7")
            case 8...14:
                print("case 8-14")
                NumberOfEmptyBox = weekday - day - 7
            case 15...21:
                print("case 15-21")
                NumberOfEmptyBox = day - weekday - 14
            case 22...28:
                print("case 22-28")
                NumberOfEmptyBox = weekday - day - 21
            case 29...31:
                print("case 29-31")
                NumberOfEmptyBox = weekday - day - 28
            default:
                break
            
            }
            PositionIndex = NumberOfEmptyBox
        print("positionIndex2 = \(PositionIndex)")
            
        case 1...:
            print("case = 1")
            print("PositionIndex before = " + String(PositionIndex))
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7 // + 0 originally
            if NextNumberOfEmptyBox == 6 {
                NextNumberOfEmptyBox = -1
            }
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            print("case = -1")
            print("PositionIndex before = " + String(PositionIndex))
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex) % 7) // + 0 originally
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            if PreviousNumberOfEmptyBox == 6 {
                PreviousNumberOfEmptyBox = -1
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return DaysInMonths[month] + 1
        print("LINE 248")
        switch Direction {
        case 0:
            print("NumberOfEmptyBox = \(NumberOfEmptyBox)")
            return DaysInMonths[month] + 1 + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + 1 + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + 1 + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        
        
        cell.backgroundColor = UIColor.systemGray5
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.layer.borderWidth = 1
        
        switch Direction {
        case 0:
            //print("line 262 case = 0")
            print("NumberOfEmptyBox = \(NumberOfEmptyBox)")
            cell.DateLabel.text = "\(indexPath.row - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.DateLabel.text!)! < 1 {
            cell.isHidden = true
        } else {
            cell.isHidden = false
        }
        
        let cellDate = [year,month,Int(cell.DateLabel.text!)!]
        
        for day in completedDays {
            if day == cellDate {
                cell.backgroundColor = UIColor.blue
            }
        }
        
        // checks for current day, makes it yellow
        if Int(cell.DateLabel.text!)! == day && currentCalendar.component(.month, from: date) == month + 1 && currentYearInt == year{
            cell.backgroundColor = UIColor.yellow //needs custom color for dark mode
            cell.DateLabel.backgroundColor = UIColor.yellow
        } else {
            //cell.backgroundColor = UIColor.systemGray5
            cell.DateLabel.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        
        let cellDate = [year,month,Int(cell.DateLabel.text!)!]
        let currentDate = [currentYearInt,currentMonthInt,day]
        
        if isDateBeforeDate(date1: cellDate, date2: currentDate) || cellDate == currentDate{
            if cell.backgroundColor == UIColor.blue {
                let firstIndex = completedDays.firstIndex(of: cellDate)
                completedDays.remove(at: firstIndex!)     // needs revision
                cell.backgroundColor = UIColor.systemGray5
            } else {
                //completedDays.append(cellDate)
                completedDays = pushDate(stack: completedDays, date:cellDate)
                cell.backgroundColor = UIColor.blue
            }
            
            if currentYearInt == year && month == currentMonthInt && Int(cell.DateLabel.text!)! == day {
                if cell.backgroundColor == UIColor.blue {
                    currentStreak += 1
                } else {
                    currentStreak -= 1
                }
                streakLabel.text = "\(currentStreak)" // reloadData() type line
            }
        }
        print("completedDays = \(completedDays)")
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.Calendar.bounds.size.width / 8, height: 40)
    }
}
