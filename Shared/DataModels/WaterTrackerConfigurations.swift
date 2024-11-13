//
//  DataModels.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftData
import SwiftUI

#if DEBUG_CloudKit
import CoreData
#endif

let AppName = "Water Tracker"

@Model
class WaterTrackerConfiguration {
    // All optional to be compatible with iOS 16's SwiftData setting.
    var waterUnit: WaterUnits? = nil
    var cupCapacity: Double? = nil
    var dailyGoal: Double? = nil
    
    init(waterUnit: WaterUnits, cupCapacity: Double, dailyGoals: Double) {
        self.waterUnit = waterUnit
        self.cupCapacity = cupCapacity
        self.dailyGoal = dailyGoals
    }
}

var sharedWaterTrackerModelContainer: ModelContainer = {
    /*
     * Shared model to be synced and used everywhere in the app
     * (except in widget, come on Apple...😭)
     */
    let schema = Schema([
        WaterTrackerConfiguration.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {

        // If you haven't setup your CloudKit correctly, THIS WILL CRASH.
        // Therefore, just comment them out using #if DEBUG_CloudKit for now.
#if DEBUG_CloudKit
//     Use an autorelease pool to make sure Swift deallocates the persistent
//     container before setting up the SwiftData stack.
    try autoreleasepool {
        let desc = NSPersistentStoreDescription(url: modelConfiguration.url)
        let opts = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.SimpleWaterTrackerCloudKit")
        desc.cloudKitContainerOptions = opts
        // Load the store synchronously so it completes before initializing the
        // CloudKit schema.
        desc.shouldAddStoreAsynchronously = false
        if let mom = NSManagedObjectModel.makeManagedObjectModel(for: [WaterTrackerConfiguration.self]) {
            let container = NSPersistentCloudKitContainer(name: "SimpleWaterTracker", managedObjectModel: mom)
            container.persistentStoreDescriptions = [desc]
            container.loadPersistentStores {_, err in
                if let err {
                    fatalError(err.localizedDescription)
                }
            }
            // Initialize the CloudKit schema after the store finishes loading.
            try container.initializeCloudKitSchema()
            // Remove and unload the store from the persistent container.
            if let store = container.persistentStoreCoordinator.persistentStores.first {
                try container.persistentStoreCoordinator.remove(store)
            }
        }
    }
#endif
    
        return try ModelContainer(for: schema, configurations: modelConfiguration)
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@Observable
class WaterTrackerConfigManager {
    /*
     * Manager for the WaterTracker Configurations (SwiftData),
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
    
    var config: WaterTrackerConfiguration? = nil
    
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

    func updateWaterTrackerConfig(modelContext: ModelContext) {
        do {
            let fecthDescriptor = FetchDescriptor<WaterTrackerConfiguration>()
            let all_save = try modelContext.fetch(fecthDescriptor)
            
            if let data = all_save.first {
                self.config = data
            } else {
                // No custom value, use default.
                self.config = WaterTrackerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal)
            }
        } catch {
            fatalError("Fatal Error: Fail to get model. ")
        }
    }
    
    func getWaterTrackerConfiguration(modelContext: ModelContext) -> WaterTrackerConfiguration {
        self.updateWaterTrackerConfig(modelContext: modelContext)
        return self.config ?? WaterTrackerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal)
    }
    
    func setWaterUnit(_ waterUnit: WaterUnits, modelContext: ModelContext) {
        
        let waterTrackerConfiguration = self.getWaterTrackerConfiguration(modelContext: modelContext)
        
        waterTrackerConfiguration.waterUnit = waterUnit
        waterTrackerConfiguration.cupCapacity = nil
        waterTrackerConfiguration.dailyGoal = nil
        
        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setCupCapacity(_ newCupCapacity: Double, modelContext: ModelContext) {
        let waterTrackerConfiguration = getWaterTrackerConfiguration(modelContext: modelContext)
        
        waterTrackerConfiguration.cupCapacity = newCupCapacity
        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setDailyGoal(_ newDailyGoal: Double, modelContext: ModelContext) {
        let waterTrackerConfiguration = getWaterTrackerConfiguration(modelContext: modelContext)
        
        waterTrackerConfiguration.dailyGoal = newDailyGoal
        modelContext.insert(waterTrackerConfiguration)
        do {
            // This will override the original save, not append.
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    
    func setWaterTrackerConfiguration(_ newConfig: WaterTrackerConfiguration, modelContext: ModelContext) {
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

