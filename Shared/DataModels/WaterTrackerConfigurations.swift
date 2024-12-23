//
//  DataModels.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftData
import SwiftUI

#if DEBUG_CLOUDKIT
import CoreData
#endif

let AppName = String(localized: "Pocket Water Tracker")

@Model
class WaterTrackerConfiguration {
    /*
     * Data Model Attention (as of iOS 17 and iOS 18):
     * All values stored in the SwiftData MUST BE either optional or contains a default value,
     * including the init function (where all parameters must contain default value).
     * Otherwise, this SwiftData model would not sync with iCloud and could potentially crash
     * in iOS 17 (unknown reason).
     */
    var waterUnit: WaterUnits? = nil
    var cupCapacity: Double? = nil
    var dailyGoal: Double? = nil
    var reminderTimeInterval: TimeInterval? = nil
    
    init(waterUnit: WaterUnits = .ml, cupCapacity: Double = 600.0, dailyGoals: Double = 2400.0, reminderTimeInterval: TimeInterval = 7200.0) {
        self.waterUnit = waterUnit
        self.cupCapacity = cupCapacity
        self.dailyGoal = dailyGoals
        self.reminderTimeInterval = reminderTimeInterval
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

        /*
         * If you haven't setup your CloudKit on your Apple Deverloper Account correctly, THIS WILL CRASH!
         * Therefore, just comment them out using #if DEBUG_CLOUDKIT for now.
         */
#if DEBUG_CLOUDKIT
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
    
    var reminderTimeInterval: TimeInterval {
        get{
            return self.getReminderTimeInterval()
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
    
    func getReminderTimeInterval() -> TimeInterval {
        return self.config?.reminderTimeInterval ?? 7200.0
    }
    
    func deleteAllWaterTrackerConfigIfExists(modelContext: ModelContext) {
        do {
            let fecthDescriptor = FetchDescriptor<WaterTrackerConfiguration>()
            let all_save = try modelContext.fetch(fecthDescriptor)
            
            for cur_save in all_save {
                modelContext.delete(cur_save)
            }
        } catch {
            fatalError("Fatal Error: Fail to get model. ")
        }
    }

    func receiveUpdatedWaterTrackerConfig(modelContext: ModelContext) {
        do {
            let fecthDescriptor = FetchDescriptor<WaterTrackerConfiguration>()
            let all_save = try modelContext.fetch(fecthDescriptor)
            
            if let data = all_save.last {
                // It is important to DEEP COPY the config here.
                // Otherwise, the original SwiftData won't be modified/deleted correctly.
                self.config = WaterTrackerConfiguration(waterUnit: data.waterUnit ?? .ml, cupCapacity: data.cupCapacity ?? WaterUnits.ml.cupDefaultCapacity, dailyGoals: data.dailyGoal ?? WaterUnits.ml.defaultDailyGoal, reminderTimeInterval: data.reminderTimeInterval ?? 7200.0)
            } else {
                // No custom value, use default.
                self.config = WaterTrackerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal, reminderTimeInterval: 7200.0)
            }
        } catch {
            fatalError("Fatal Error: Fail to get model. ")
        }
    }
    
    func getWaterTrackerConfiguration(modelContext: ModelContext) -> WaterTrackerConfiguration {
        self.receiveUpdatedWaterTrackerConfig(modelContext: modelContext)
        return self.config ?? WaterTrackerConfiguration(waterUnit: .ml, cupCapacity: WaterUnits.ml.cupDefaultCapacity, dailyGoals: WaterUnits.ml.defaultDailyGoal, reminderTimeInterval: 7200.0)
    }
    
    func setWaterUnit(_ waterUnit: WaterUnits, modelContext: ModelContext) {
        let waterTrackerConfiguration = self.getWaterTrackerConfiguration(modelContext: modelContext)
        deleteAllWaterTrackerConfigIfExists(modelContext: modelContext)
        
        // Reset other settings to match the unit change.
        waterTrackerConfiguration.waterUnit = waterUnit
        waterTrackerConfiguration.cupCapacity = waterUnit.cupDefaultCapacity
        waterTrackerConfiguration.dailyGoal = waterUnit.defaultDailyGoal
        
        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setCupCapacity(_ newCupCapacity: Double, modelContext: ModelContext) {
        let waterTrackerConfiguration = getWaterTrackerConfiguration(modelContext: modelContext)
        deleteAllWaterTrackerConfigIfExists(modelContext: modelContext)

        waterTrackerConfiguration.cupCapacity = newCupCapacity

        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setDailyGoal(_ newDailyGoal: Double, modelContext: ModelContext) {
        let waterTrackerConfiguration = getWaterTrackerConfiguration(modelContext: modelContext)
        deleteAllWaterTrackerConfigIfExists(modelContext: modelContext)

        waterTrackerConfiguration.dailyGoal = newDailyGoal
        
        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setReminderTimeInterval(_ newInterval: TimeInterval, modelContext: ModelContext) {
        let waterTrackerConfiguration = getWaterTrackerConfiguration(modelContext: modelContext)
        deleteAllWaterTrackerConfigIfExists(modelContext: modelContext)

        waterTrackerConfiguration.reminderTimeInterval = newInterval
        
        self.config = waterTrackerConfiguration
        modelContext.insert(waterTrackerConfiguration)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

