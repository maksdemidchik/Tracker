//
//  HabitAndScheduleServices.swift
//  Tracker
//
//  Created by Maxim on 25.04.2025.
//

import Foundation

final class CreateNewTrackerAndScheduleServices {
    static let shared = CreateNewTrackerAndScheduleServices()
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
    
    let numberOfDaysInt = [2,3,4,5,6,7,1]
    
    var schdule : [String] = []
    
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
            let text = NSLocalizedString("everyDay", comment: "everyDay")
            string = text
        }
        return string
    }
    
    func setIndexPathAndNameCategory(indexPath: IndexPath,nameCategory: String){
        previousIndexPath = currentIndexPath
        curruntCategory = nameCategory
        currentIndexPath = indexPath
    }
    
    func remove(){
        curruntCategory = ""
        currentIndexPath = nil
        previousIndexPath = nil
        schdule.removeAll()
        numberOfDays.removeAll()
        numberOfDaysForDateInt.removeAll()
    }
    
}
