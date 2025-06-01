//
//  OnboardingService.swift
//  Tracker
//
//  Created by Maxim on 25.05.2025.
//

import Foundation
final class OnboardingService{
    static let shared = OnboardingService()
    private init(){}
    var isOnboardingCompleted: Bool {
        get{
            UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "isOnboardingCompleted")
        }
    }
    
}
