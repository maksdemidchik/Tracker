//
//  HabitAndScheduleServices.swift
//  Tracker
//
//  Created by Maxim on 25.04.2025.
//

import Foundation

final class HabitAndScheduleServices {
    static let shared = HabitAndScheduleServices()
    
    private init() {}
    
    let abbreviationOfNamesDays = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    
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
    
    func setSchudule() -> String{
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
    
    func remove(){
        schdule.removeAll()
        numberOfDays.removeAll()
        numberOfDaysForDateInt.removeAll()
    }
    
}
