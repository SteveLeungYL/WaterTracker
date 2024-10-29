//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct CupView: View {
    @State private var percent: Double = 20
    @State private var waveOffset = Angle(degrees: 0)
    
    var body : some View {
        
        GeometryReader { geometry in
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    ZStack{
                        
                        @State var cupWidth = geometry.size.width * 0.8
                        
                        Cup()
                            .fill(Color.white)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: cupWidth, alignment: .center)
                            .overlay(
                                WaveAnimation($percent, $waveOffset)
                                    .frame(width: cupWidth, alignment: .center)
                                    .aspectRatio( contentMode: .fill)
                                    .mask(
                                Cup()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: cupWidth, alignment: .center)
                                )
                            )
                        
                        
                        Cup()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 8))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: cupWidth, alignment: .center)
                            .overlay(
                                InvisibleSlider(percent: $percent, waveOffset: $waveOffset)
                            )
                        
                        // FIXME: Update the correct text here.
                        Text("\(Int(percent))%")
                            .font(.system(size: 300))
                            .minimumScaleFactor(0.00001)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(height: cupWidth * 0.30, alignment: .center)
                            .allowsHitTesting(false)
                        
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    CupView()
}
