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

func getCupCapacity(config: WaterTracerConfiguration) -> Double {
    return config.cupCapacity ?? config.waterUnit.cupDefaultCapacity
}

func getCupMinimumNum(config: WaterTracerConfiguration) -> Double {
    return config.waterUnit.cupMinimumNum
}

func getUnitStep(config: WaterTracerConfiguration) -> Double {
    return config.waterUnit.unitStep
}

func getUnitStr(config: WaterTracerConfiguration) -> String {
    return config.waterUnit.unitStr
}

func getDailyGoal(config: WaterTracerConfiguration) -> Double {
    if let dailyGoal = config.dailyGoal {
        return dailyGoal
    } else {
        return config.waterUnit.defaultDailyGoal
    }
}

func getWaterTracerConfiguration(modelContext: ModelContext) -> WaterTracerConfiguration {
    
    do {
        let fecthDescriptor = FetchDescriptor<WaterTracerConfiguration>(predicate: nil)
        let all_save = try modelContext.fetch(fecthDescriptor)
        
        if let data = all_save.first {
            return data
        } else {
            // No custom value, use default.
            return WaterTracerConfiguration()
        }
    } catch {
        print("Warnaing: Fail to get model. Use default. ")
        return WaterTracerConfiguration()
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
