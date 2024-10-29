//
//  InvisibleSlider.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//

import SwiftUI

struct InvisibleSlider: View {
    
    @Binding var percent: Double
    @Binding var waveOffset: Angle
    
    var body: some View {
        GeometryReader { geo in
            #if !os(watchOS)
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.percent = max(0, min(100, percent * 100))
                    // FIXME: This is still not perfect.
                    // The waveanimation will stop when we adjust the slider.
                    //                    waveOffset += Angle(degrees: max(0, min(100, percent * 100)) / 4)
                }
                .onEnded { value in
                    waveOffset = waveOffset + Angle(degrees: 360)
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
                .digitalCrownRotation(detent: $percent,
                                      from: 0.0,
                                      through: 100.0,
                                      by: 5.0,
                                      isContinuous: false
                ) { crownEvent in
                } onIdle: {
                    waveOffset = waveOffset + Angle(degrees: 360)
                }
                .scrollIndicators(.hidden)
#endif
        }
    }
    
}

#Preview {
    @Previewable @State var percent: Double = 20
    @Previewable @State var waveOffset: Angle = Angle(degrees: 0.0)
    InvisibleSlider(percent: $percent, waveOffset: $waveOffset)
}
