//
//  WaterTracingBarChart.swift
//  WaterTracer
//
//  Created by Yu Liang on 11/4/24.
//


//
//  WeightDiffBarChart.swift
//  WaterTracer
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
    @State var healthKitManager: HealthKitManager
    
    //    @State private var rawSelectedDate: Date?
    @State var config: WaterTracerConfigManager
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
        .onAppear {
            Task{
                let container = try ModelContainer(for: WaterTracerConfiguration.self)
                let context = ModelContext(container)
                config.updateWaterTracerConfig(modelContext: context)
                _ =  healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.progress = healthKitManager.todayTotalDrinkNum / config.getDailyGoal()
                }
            }
        }
        .onChange(of: updateToggle) {
            _ =  healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progress = healthKitManager.todayTotalDrinkNum / config.getDailyGoal()
            }
        }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var config = WaterTracerConfigManager()
    @Previewable @State var updateToggle = false
    CircularProgressView(healthKitManager: healthKitManager, config: config, updateToggle: $updateToggle)
}
