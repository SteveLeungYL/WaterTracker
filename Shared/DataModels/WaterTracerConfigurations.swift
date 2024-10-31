//
//  DataModels.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftData
import SwiftUI

@Model
class WaterTracerConfiguration {
    var waterUnit: WaterUnits = WaterUnits.ml
    var cupCapacity: Double? = nil
    var dailyGoal: Double? = nil

    init(waterUnit: WaterUnits, cupCapacity: Double, dailyGoals: Double) {
        self.waterUnit = waterUnit
        self.cupCapacity = cupCapacity
        self.dailyGoal = dailyGoals
    }
    init() {
        self.waterUnit = WaterUnits.ml
        self.cupCapacity = nil
        self.dailyGoal = nil
    }
}

var sharedWaterTracerModelContainer: ModelContainer = {
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
            return self.config.waterUnit
        }
    }
    
    var config = WaterTracerConfiguration()
    
    func getUnit() -> WaterUnits {
        return self.config.waterUnit
    }
    
    func getCupCapacity() -> Double {
        return self.config.cupCapacity ?? config.waterUnit.cupDefaultCapacity
    }

    func getCupMinimumNum() -> Double {
        return self.config.waterUnit.cupMinimumNum
    }

    func getUnitStep() -> Double {
        return self.config.waterUnit.unitStep
    }

    func getUnitStr() -> String {
        return self.config.waterUnit.unitStr
    }

    func getDailyGoal() -> Double {
        if let dailyGoal = self.config.dailyGoal {
            return dailyGoal
        } else {
            return self.config.waterUnit.defaultDailyGoal
        }
    }
    
    func updateWaterTracerConfig(modelContext: ModelContext) {
        do {
            let fecthDescriptor = FetchDescriptor<WaterTracerConfiguration>(predicate: nil)
            let all_save = try modelContext.fetch(fecthDescriptor)
            
            if let data = all_save.first {
                self.config = data
            } else {
                // No custom value, use default.
                self.config = WaterTracerConfiguration()
            }
        } catch {
            print("Warnaing: Fail to get model. Use default. ")
        }
    }

    func getWaterTracerConfiguration(modelContext: ModelContext) -> WaterTracerConfiguration {
        self.updateWaterTracerConfig(modelContext: modelContext)
        return self.config
    }
}

//class WaterTracerConfigurationManager {
//
//    var ModelContext: ModelContext? = nil
//
//    static func getWaterTracerConfiguration() -> WaterTracerConfiguration {
//        @Environment(\.modelContext) var modelContext
//
//        do {
//            let fecthDescriptor = FetchDescriptor<WaterTracerConfiguration>(predicate: nil)
//            let all_save = try modelContext.fetch(fecthDescriptor)
//
//            if let data = all_save.first {
//                return data
//            } else {
//                // No custom value, use default.
//                return WaterTracerConfiguration()
//            }
//        } catch {
//            print("Warnaing: Fail to get model. Use default. ")
//            return WaterTracerConfiguration()
//        }
//    }
//
//    static func getCupCapacity() -> Double {
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        return waterTracerConfiguration.cupCapacity ?? waterTracerConfiguration.waterUnit.cupDefaultCapacity
//    }
//
//    static func getCupMinimumNum() -> Double {
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        return waterTracerConfiguration.waterUnit.cupMinimumNum
//    }
//
//    static func getUnitStr() -> String {
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        if waterTracerConfiguration.waterUnit == WaterUnits.ml {
//            return "ml"
//        } else {
//            return "oz"
//        }
//    }
//
//    static func deleteAllWaterTracerConfigs() {
//        @Environment(\.modelContext) var modelContext
//        do {
//            try modelContext.delete(model: WaterTracerConfiguration.self)
//        } catch {
//            print("Failed to delete all? \(error.localizedDescription)")
//        }
//    }
//
//    static func setWaterUnit(_ waterUnit: WaterUnits) {
//        @Environment(\.modelContext) var modelContext
//
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        self.deleteAllWaterTracerConfigs()
//
//        waterTracerConfiguration.waterUnit = waterUnit
//        waterTracerConfiguration.cupCapacity = nil
//        modelContext.insert(waterTracerConfiguration)
//        do {
//            try modelContext.save()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    static func setCupCapacity(_ newCupCapacity: Double) {
//        @Environment(\.modelContext) var modelContext
//
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        self.deleteAllWaterTracerConfigs()
//
//        waterTracerConfiguration.cupCapacity = newCupCapacity
//        modelContext.insert(waterTracerConfiguration)
//        do {
//            try modelContext.save()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//    static func setWaterTracerConfiguration(_ newConfig: WaterTracerConfiguration) {
//        @Environment(\.modelContext) var modelContext
//
//        let waterTracerConfiguration = getWaterTracerConfiguration()
//        self.deleteAllWaterTracerConfigs()
//
//        modelContext.insert(newConfig)
//        do {
//            try modelContext.save()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//
//}
