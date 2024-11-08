//
//  UnitPicker.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/31/24.
//

import SwiftUI

struct UnitPickerView: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config
    @Environment(\.modelContext) var modelContext
    
    @Binding var updateToggle: Bool
    
    @State private var waterUnitSelection: String = ""
    @State private var waterUnitChoice = ["Milliliter", "Ounce", ""]
    
    @State private var dailyGoal: Double = 0.0
    @State private var dailyGoalChoice: [Double] = [2500]
    
    init(updateToggle: Binding<Bool>) {
        self._updateToggle = updateToggle
    }
    
    var body : some View {
        
        NavigationStack {
            
#if os(iOS)
            HStack{
                
                Text("Daily Goal: ")
                    .font(.title)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .allowsHitTesting(false)
                    .multilineTextAlignment(.leading)
                // Make it at the bottom.
                Text("[1]")
                    .font(.system(size: 8))
                    .foregroundStyle(.black)
                    .baselineOffset(6.0)
                
                
                Picker("", selection: self.$dailyGoal) {
                    ForEach(self.dailyGoalChoice, id: \.self) {
                        let unitStr = self.config.waterUnit == .ml ? "ml" : "oz"
                        Text(String("\($0) \(unitStr)"))
                    }
                }
                .pickerStyle(.wheel)
                .foregroundStyle(.black)
                .accentColor(.black)
                .multilineTextAlignment(.center)
                .labelsHidden()
                .onAppear {
                    self.dailyGoal = self.config.getDailyGoal()
                    self.dailyGoalChoice = self.config.getDailyGoalCustomRange()
                }
                .onChange(of: self.dailyGoal) { oldValue, newValue in
                    if oldValue != 0.0 {
                        self.config.setDailyGoal(self.dailyGoal, modelContext: modelContext)
                        updateToggle = !updateToggle
                    }
                }
            }
#endif
            
            HStack{
                
                Text("Choose Unit: ")
#if !os(watchOS)
                    .font(.title)
#else
                    .font(.body)
#endif
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                    .allowsHitTesting(false)
                    .multilineTextAlignment(.leading)
                
                Picker("", selection: self.$waterUnitSelection) {
                    ForEach(self.waterUnitChoice, id: \.self) {
                        Text(LocalizedStringKey($0))
                    }
                }
#if os(watchOS)
                .pickerStyle(.navigationLink)
#else
                .pickerStyle(SegmentedPickerStyle())
#endif
                .foregroundStyle(.black)
                .accentColor(.black)
                .multilineTextAlignment(.center)
                .labelsHidden()
                .onAppear {
                    if self.config.waterUnit == .ml {
                        self.waterUnitSelection = "Milliliter"
                    } else {
                        self.waterUnitSelection = "Ounce"
                    }
                    // Remove the empty choice.
                    self.waterUnitChoice = ["Milliliter", "Ounce"]
                }
                .onChange(of: waterUnitSelection) { oldValue, newValue in
                    if newValue == "Milliliter" && oldValue != "" {
                        self.config.setWaterUnit(.ml, modelContext: modelContext)
                        self.dailyGoalChoice = self.config.getDailyGoalCustomRange()
                        self.dailyGoal = self.config.getDailyGoal()
                        updateToggle = !updateToggle
                    }
                    else if newValue == "Ounce" && oldValue != "" {
                        self.config.setWaterUnit(.oz, modelContext: modelContext)
                        self.dailyGoalChoice = self.config.getDailyGoalCustomRange()
                        self.dailyGoal = self.config.getDailyGoal()
                        updateToggle = !updateToggle
                    }
                }
            }
        }
    }
    
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    @Previewable @State var updateToggle = false
    
    UnitPickerView(updateToggle: $updateToggle)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .environment(healthKitManager)
        .environment(configManager)
}
