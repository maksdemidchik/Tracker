//
//  TrackerScreenshotTest.swift
//  TrackerScreenshotTest
//
//  Created by Maxim on 05.06.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerScreenshotTest: XCTestCase {
    func testTrackerViewController() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image)
    }
    func testChoosingCategoryOrHabit(){
        let vc = ChoosingCategoryOrHabit()
        assertSnapshot(matching: vc, as: .image)
    }
    //cкриншот делал на iPhone 16 pro
}
