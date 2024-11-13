//
//  InvisibleSlider.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//

import SwiftUI

struct InvisibleSlider: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config

    @State var scroll: Double = 0.0

    var body: some View {
        GeometryReader { geo in
            #if !os(watchOS)
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.healthKitManager.drinkNum = max(config.cupMinimumNum, min(config.cupCapacity, percent * config.cupCapacity))
                }
            #endif
            
            Rectangle()
                .opacity(0.00001) // The super small value will effectively hide the slider.
                .frame(width: geo.size.width, height: geo.size.height)
            #if !os(watchOS)
                .gesture(dragGesture)
            #endif
            
#if os(watchOS)
            Text("For Digital Crown")
                .opacity(0.000001)
                .focusable()
                .digitalCrownRotation(detent: $scroll,
                                      from: 0.0,
                                      through: 10000.0, // arbitrary large number
                                      by: 1.0,
                                      isContinuous: false
                ) { crownEvent in
                }
                .scrollIndicators(.hidden)
#endif
        }.onAppear() {
            self.scroll = Double(self.healthKitManager.drinkNum - config.cupMinimumNum) / config.adjustStep
        }
#if os(watchOS)
        .onChange(of: scroll) {
            self.healthKitManager.drinkNum = max(config.cupMinimumNum, min(config.cupCapacity, Double(scroll) * config.adjustStep + config.cupMinimumNum))
            if (scroll > (config.cupCapacity - config.cupMinimumNum) / config.adjustStep) {
                scroll = ((config.cupCapacity - config.cupMinimumNum) / config.adjustStep)
            }
        }
#endif
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    ZStack{
        InvisibleSlider()
        Text(String(format:"%.1f", healthKitManager.drinkNum))
            .font(.largeTitle)
    }
    .environment(healthKitManager)
    .environment(configManager)
}
