//
//  DataModels.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftData
import SwiftUI

let AppName = "Water Tracer"

@Model
class WaterTracerConfiguration {
    // All optional to be compatible with iOS 16's SwiftData setting.
    var waterUnit: WaterUnits?
    var cupCapacity: Double?
    var dailyGoal: Double?
    
    init(waterUnit: WaterUnits, cupCapacity: Double, dailyGoals: Double) {
        self.waterUnit = waterUnit
        self.cupCapacity = cupCapacity
        self.dailyGoal = dailyGoals
    }
}

var sharedWaterTracerModelContainer: ModelContainer = {
    /*
     * Shared model to be synced and used everywhere in the app
     * (except in widget, come on Apple...😭)
     */
    let schema = Schema([
        WaterTracerConfiguration.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@Observable
class WaterTracerConfigManager {
    /*
     * Manager for the WaterTracer Configurations (SwiftData),
     * provide an abstraction above the SwiftData @Model struct.
     * If no custom setting saved, return the default one.
     */
    
    var cupMinimumNum: Double {
        get{
            return self.getCupMinimumNum()
        }
    }
    var cupCapacity: Double {
        get{
            return self.getCupCapacity()
        }
    }
    var adjustStep: Double {
        get{
            return self.getUnitStep()
        }
    }
    
    var waterUnit: WaterUnits {
        get {
            return self.config?.waterUnit ?? .ml
        }
    }
    
    var config: WaterTracerConfiguration? = nil
    
    func getUnit() -> WaterUnits {
        return self.config?.waterUnit ?? .ml
    }
    
    func getCupCapacity() -> Double {
        return self.config?.cupCapacity ?? config?.waterUnit?.cupDefaultCapacity ?? WaterUnits.ml.cupDefaultCapacity
    }
    
    func getCupMinimumNum() -> Double {
        return self.config?.waterUnit?.cupMinimumNum ?? WaterUnits.ml.cupMinimumNum
    }
    
    func getUnitStep() -> Double {
        return self.config?.waterUnit?.unitStep ?? WaterUnits.ml.unitStep
    }
    
    func getUnitStr() -> String {
        return self.config?.waterUnit?.unitStr ?? WaterUnits.ml.unitStr
    }
    
    func getDailyGoal() -> Double {
        if let dailyGoal = self.config?.dailyGoal {
            return dailyGoal
        } else {
            return self.config?.waterUnit?.defaultDailyGoal ?? WaterUnits.ml.defaultDailyGoal
        }
    }
    
    func getDailyGoalCustomRange() -> [Double] {
        return self.config?.waterUnit?.dailyGoalRange ?? WaterUnits.ml.dailyGoalRange
    }

    func updateWaterTracerConfig(modelContext: ModelContext) {
        do {
            let fecthDescriptor = FetchDescriptor<WaterTracerConfiguration>()
            let all_save = try modelContext.fetch(fecthDescriptor)
            
            if let data = all_save.first {
                self.config = data
            } else {
                // No custom value, use default.
                self.config = WaterTracerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal)
            }
        } catch {
            fatalError("Fatal Error: Fail to get model. ")
        }
    }
    
    func getWaterTracerConfiguration(modelContext: ModelContext) -> WaterTracerConfiguration {
        self.updateWaterTracerConfig(modelContext: modelContext)
        return self.config ?? WaterTracerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal)
    }
    
    func setWaterUnit(_ waterUnit: WaterUnits, modelContext: ModelContext) {
        
        let waterTracerConfiguration = self.getWaterTracerConfiguration(modelContext: modelContext)
        
        waterTracerConfiguration.waterUnit = waterUnit
        waterTracerConfiguration.cupCapacity = nil
        waterTracerConfiguration.dailyGoal = nil
        
        self.config = waterTracerConfiguration
        modelContext.insert(waterTracerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setCupCapacity(_ newCupCapacity: Double, modelContext: ModelContext) {
        let waterTracerConfiguration = getWaterTracerConfiguration(modelContext: modelContext)
        
        waterTracerConfiguration.cupCapacity = newCupCapacity
        self.config = waterTracerConfiguration
        modelContext.insert(waterTracerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setDailyGoal(_ newDailyGoal: Double, modelContext: ModelContext) {
        let waterTracerConfiguration = getWaterTracerConfiguration(modelContext: modelContext)
        
        waterTracerConfiguration.dailyGoal = newDailyGoal
        modelContext.insert(waterTracerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    
    func setWaterTracerConfiguration(_ newConfig: WaterTracerConfiguration, modelContext: ModelContext) {
        self.config = newConfig
        modelContext.insert(newConfig)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

