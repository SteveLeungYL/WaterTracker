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
    
    @State private var waterUnitSelection: String = "Miniliter\nml"
    private var waterUnitChoice = ["Miniliter\nml", "Ounce\noz"]
    
    init(updateToggle: Binding<Bool>) {
        self._updateToggle = updateToggle
    }
    
    var body : some View {
        
        NavigationStack {
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
                        Text($0)
                    }
                }
#if os(watchOS)
                .pickerStyle(.navigationLink)
                #else
                .pickerStyle(SegmentedPickerStyle())
#endif
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
                .labelsHidden()
                .onAppear {
                    if self.config.waterUnit == .ml {
                        self.waterUnitSelection = "Miniliter\nml"
                    } else {
                        self.waterUnitSelection = "Ounce\noz"
                    }
                }
                .onChange(of: waterUnitSelection) { oldValue, newValue in
                    if newValue == "Miniliter\nml" {
                        self.config.setWaterUnit(.ml, modelContext: modelContext)
                        updateToggle = !updateToggle
                    }
                    else if newValue == "Ounce\noz" {
                        self.config.setWaterUnit(.oz, modelContext: modelContext)
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
