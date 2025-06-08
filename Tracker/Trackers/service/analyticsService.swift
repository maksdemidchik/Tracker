//
//  analyticsService.swift
//  Tracker
//
//  Created by Maxim on 08.06.2025.
//

import Foundation
import YandexMobileMetrica
final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() {}
    
    func reportEvent(_ event: String, parameters: [AnyHashable: Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
