//
//  WaterTracingBarChart.swift
//  WaterTracker
//
//  Created by Yu Liang on 11/4/24.
//


//
//  WeightDiffBarChart.swift
//  WaterTracker
//
//  Modified by Yu Liang on 10/31/24.
//

//
//  WeightDiffBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import Charts
import SwiftData

struct CircularProgressView: View {
    /* A dump circular progress bar view. Might be replaced by built-in progress bar later */
    @Environment(HealthKitManager.self) private var healthKitManager
    
    //    @State private var rawSelectedDate: Date?
    @State var config: WaterTrackerConfigManager
    @State var progress: Double = 0.00
    
#if !os(watchOS)
    @State var lineWidth: Double = 10.0
#else
    @State var lineWidth: Double = 5.0
#endif
    
    @Binding var updateToggle: Bool
    var isShowText: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer(minLength: 0)
                VStack{
                    Spacer(minLength: 0)
                    
                    ZStack {
                        Circle()
                            .stroke(
                                Color.blue.opacity(0.3),
                                lineWidth: self.lineWidth
                            )
#if !os(watchOS)
                            .frame(width: geometry.size.width * 0.9, alignment: .center)
#else
                            .frame(width: geometry.size.width * 0.6, alignment: .center)
#endif
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                Color.blue,
                                style: StrokeStyle(
                                    lineWidth: self.lineWidth,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(90))
                            .animation(.easeOut, value: progress)
#if !os(watchOS)
                            .frame(width: geometry.size.width * 0.9, alignment: .center)
#else
                            .frame(width: geometry.size.width * 0.6, alignment: .center)
#endif
                        
                        //                        Text(String("\(Int(progress * 100))%"))
                        if isShowText {
                            Text(String(format: "%d%%", Int(progress * 100)))
                                .font(.system(size: 300))
                                .minimumScaleFactor(0.00001)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80, alignment: .center)
                                .allowsHitTesting(false)
                        }
                    }
                    Spacer(minLength: 0)
                }
                Spacer(minLength: 0)
            }
        }
        .onChange(of: updateToggle) {
            Task {
                let context = ModelContext(sharedWaterTrackerModelContainer)
                config.updateWaterTrackerConfig(modelContext: context)
                /* Get week data can retrieve the last date as today. */
                _ = await healthKitManager.updateDrinkWaterWeek(waterUnitInput: config.waterUnit)
                DispatchQueue.main.async {
                    self.progress = (healthKitManager.drinkWeekData.last?.value ?? 0.0) / config.getDailyGoal()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var config = WaterTrackerConfigManager()
    @Previewable @State var updateToggle = false
    CircularProgressView(config: config, updateToggle: $updateToggle)
        .environment(healthKitManager)
}
