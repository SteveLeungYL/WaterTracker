//
//  ShortCutIntent.swift
//  WaterTracker
//
//  Created by Yu Liang on 12/4/24.
//

import AppIntents
import SwiftUI
import SwiftData

struct ShortCutIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Log a water drinking event"
    
    @Parameter(title: "Drink Num")
    var drinkNum: Double
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let healthKitManager = HealthKitManager()
        let config = WaterTrackerConfigManager()
        let container = try ModelContainer(for: WaterTrackerConfiguration.self)
        let context = ModelContext(container)
        config.receiveUpdatedWaterTrackerConfig(modelContext: context)
        
        Task{
            await healthKitManager.saveDrinkWater(drink_num: self.drinkNum, waterUnitInput: config.getUnit())
        }
        
        var res_str:String.LocalizationValue = ""
        if config.getUnit() == .ml {
            let tmp_res_str = String(format:"Logged %.0f\(config.getUnitStr()) water drinking. ", drinkNum)
            res_str = String.LocalizationValue(stringLiteral: tmp_res_str)
        } else {
            let tmp_res_str = String(format:"Logged %.1f\(config.getUnitStr()) water drinking. ", drinkNum)
            res_str = String.LocalizationValue(stringLiteral: tmp_res_str)
        }
        
        return .result(dialog: IntentDialog(stringLiteral: String(localized:res_str)))
    }
    
    static let openAppWhenRun: Bool = false
}


// Siri integration
struct WaterTrackerShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShortCutIntent(),
            phrases: [
                "Log a \(.applicationName) water drinking",
                "Use \(.applicationName) to log water drinking",
                "记录\(.applicationName)喝水",
                "使用\(.applicationName)来记录喝水"
            ],
            shortTitle: "Log Drinking",
            systemImageName: "AppIcon"
        )
    }
}
