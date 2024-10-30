//
//  InvisibleSlider.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//

import SwiftUI

struct InvisibleSlider: View {
    
    @Binding var drinkNum: Double
    @Binding var waveOffset: Angle
    
    @Environment(\.modelContext) var modelContext
    @State var cupMinimumNum: Double = 10.0
    @State var cupCapacity: Double = 250.0
    @State var adjustStep: Double = 10.0
    @State var scroll: Double = 0.0

    var body: some View {
        GeometryReader { geo in
            #if !os(watchOS)
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.drinkNum = max(self.cupMinimumNum, min(cupCapacity, percent * cupCapacity))
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
                                      through: 100.0,
                                      by: 1.0,
                                      isContinuous: false
                ) { crownEvent in
                }
                .scrollIndicators(.hidden)
#endif
        }.onAppear() {
            let config = getWaterTracerConfiguration(modelContext: modelContext)
            self.cupMinimumNum = getCupMinimumNum(config:config)
            self.cupCapacity = getCupCapacity(config:config)
            self.adjustStep = getUnitStep(config:config)
            self.scroll = Double(drinkNum - cupMinimumNum) / adjustStep
        }
#if os(watchOS)
        .onChange(of: scroll) {
            self.drinkNum = max(cupMinimumNum, min(cupCapacity, Double(scroll) * adjustStep))
            if (scroll > ((cupCapacity - cupMinimumNum) / adjustStep) + 1) {
                scroll = ((cupCapacity - cupMinimumNum) / adjustStep) + 1
            }
        }
#endif
    }
}

#Preview {
    @Previewable @State var percent: Double = 20
    @Previewable @State var waveOffset: Angle = Angle(degrees: 0.0)
    InvisibleSlider(drinkNum: $percent, waveOffset: $waveOffset)
}
