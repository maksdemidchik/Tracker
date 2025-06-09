//
//  HabitAndScheduleServices.swift
//  Tracker
//
//  Created by Maxim on 25.04.2025.
//

import UIKit

final class CreateNewTrackerAndScheduleServices {
    static let shared = CreateNewTrackerAndScheduleServices()
    private let colorMarshalling = UIColorMarshalling.shared
    let scheduleDay = [
        NSLocalizedString("monday", comment: "monday"),
        NSLocalizedString("tuesday", comment: "tuesday"),
        NSLocalizedString("wednesday", comment: "wednesday"),
        NSLocalizedString("thursday", comment: "thursday"),
        NSLocalizedString("friday", comment: "friday"),
        NSLocalizedString("saturday", comment: "saturday"),
        NSLocalizedString("sunday", comment: "sunday")
    ]
    private init() {}
    var isWarning : Bool = false
    var habitOrEvent : String = ""
    let abbreviationOfNamesDays = [
        NSLocalizedString("mon", comment: "monday"),
        NSLocalizedString("tue", comment: "tue"),
        NSLocalizedString("wed", comment: "wed"),
        NSLocalizedString("thu", comment: "thu"),
        NSLocalizedString("fri", comment: "fri"),
        NSLocalizedString("sat", comment: "sat"),
        NSLocalizedString("sun", comment: "sun")
    ]
    var previousIndexPath : IndexPath?
    var currentIndexPath : IndexPath?
    var curruntCategory : String = ""
    var nameOfTracker : String = ""
    var tracker : Tracker?
    let numberOfDaysInt = [2,3,4,5,6,7,1]
    var emoji : String = ""
    var schdule : [String] = []
    var color : UIColor?
    var numberOfDays : Set<Int> = []
    
    var numberOfDaysForDateInt : [Int] = []
    
    private func sort(){
        var sortArray : [String] = []
        var sortNumberOfDays : [Int] = []
        for i in 0..<7 {
            for z in 0..<schdule.count {
                if abbreviationOfNamesDays[i] == schdule[z] {
                    sortArray.append(schdule[z])
                    sortNumberOfDays.append(numberOfDaysForDateInt[z])
                    break
                }
            }
        }
        numberOfDaysForDateInt = sortNumberOfDays
        schdule = sortArray
    }
    
    func habitOrEventName(_ name: String) {
        habitOrEvent = name
    }
    
    func setWarning(){
        isWarning = true
    }
    
    func deletedWarning(){
        isWarning = false
    }
    
    func addToSchdule(numberDays: Int) {
        schdule.append(abbreviationOfNamesDays[numberDays])
        numberOfDaysForDateInt.append(numberOfDaysInt[numberDays])
        numberOfDays.insert(numberDays)
    }
    
    func removeFromSchdule(numberDays: Int) {
        numberOfDays.remove(numberDays)
        for i in 0..<schdule.count {
            if abbreviationOfNamesDays[numberDays] == schdule[i] {
                schdule.remove(at: i)
                numberOfDaysForDateInt.remove(at: i)
                break
            }
        }
    }
    
    func setSchedule() -> String{
        var string = ""
        sort()
        if schdule.count != 7{
            for i in 0..<schdule.count {
                if i != schdule.count-1 {
                    string += "\(schdule[i]), "
                }
                else{
                    string += "\(schdule[i])"
                }
            }
        }
        else{
            string = "Каждый день"
        }
        return string
    }
    
    func setIndexPathAndNameCategory(indexPath: IndexPath,nameCategory: String){
        if currentIndexPath != nil {
            previousIndexPath = currentIndexPath
        }
        curruntCategory = nameCategory
        currentIndexPath = indexPath
    }
    func setIndexPathPreviousIndexPathIfNeed(IndexPath:IndexPath){
        if previousIndexPath == nil {
            previousIndexPath = IndexPath
        }
    }
    
    func setNilIndexPath(){
        previousIndexPath = nil
        currentIndexPath = nil
    }
    func convertScheduleToString(schdule: [Int]) -> [String]{
        var number: [Int] = []
        var answer: [String] = []
        for day in schdule {
            for i in 0..<numberOfDaysInt.count{
                if day == numberOfDaysInt[i] {
                    number.append(i)
                }
            }
        }
        for i in number {
            answer.append(abbreviationOfNamesDays[i])
        }
        numberOfDays = Set(number)
        return answer
    }
    func remove(){
        curruntCategory = ""
        currentIndexPath = nil
        previousIndexPath = nil
        schdule.removeAll()
        numberOfDays.removeAll()
        numberOfDaysForDateInt.removeAll()
        emoji = ""
        color = nil
        nameOfTracker = ""
    }
    
    func setTrackerAndCategoryName(tracker: Tracker,name: String){
        self.schdule = convertScheduleToString(schdule: tracker.schedule)
        self.numberOfDaysForDateInt = tracker.schedule
        self.curruntCategory = name
        self.nameOfTracker = tracker.name
        self.emoji = tracker.emoji
        self.color = tracker.color
    }
    
    func emojiComparison(emoji: String) -> Bool {
        return self.emoji == emoji
    }
    
    func colorComparison(color: UIColor) -> Bool{
        if let colorTracker = self.color{
            return colorMarshalling.hexString(from: colorTracker) == colorMarshalling.hexString(from: color)
        }
        return false
    }
}
