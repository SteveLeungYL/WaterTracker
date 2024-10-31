//
//  RingView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftUI

struct RingView: View {
    
    @State private var drinkNum: Double = 250.0 // default 100 ml
    @State private var waveOffset = Angle(degrees: 0)
    
    var body : some View {
        GeometryReader { geometry in
        @State var bodyWidth = geometry.size.width * 0.8
        ScrollView {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        ZStack{
                            BodyShape()
                                .fill(Color.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bodyWidth, alignment: .center)
                                .overlay(
                                    WaveAnimation($drinkNum, $waveOffset, false)
                                        .frame(width: bodyWidth, alignment: .center)
                                        .aspectRatio( contentMode: .fill)
                                        .mask(
                                            BodyShape()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: bodyWidth, alignment: .center)
                                        )
                                )
                            
                            
                            BodyShape()
#if !os(watchOS)
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 8))
#else
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 5))
#endif
                            
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bodyWidth, alignment: .center)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    RingView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
}
