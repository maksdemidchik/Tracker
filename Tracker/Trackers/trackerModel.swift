//
//  trackerModer.swift
//  Tracker
//
//  Created by Maxim on 21.04.2025.
//

import UIKit

struct Tracker{
    let id : UUID
    let color : UIColor
    let name : String
    let emoji : String
    let schedule :  Array<Int>
    let dateOfAddition : Date
    let isItPinned : Bool
}

struct TrackerCategory{
    let categoryName : String
    let tracker : [Tracker]
}

struct TrackerRecord{
    let id : UUID
    let date : Date
}

