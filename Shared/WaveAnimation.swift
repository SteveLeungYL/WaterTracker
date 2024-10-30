//
//  WaveAnimation.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//  Copied by Yu Liang from https://github.com/RedDragonJ/Swift-Learning/tree/main/Animations/Animations/Animations
//  Created by James Layton on 8/7/23.

import SwiftUI

struct WaveAnimation: View {
    
    @Binding var drinkNum: Double
    @Binding var waveOffset: Angle
    
    init(_ drinkNum: Binding<Double>, _ waveOffset: Binding<Angle>) {
        self._drinkNum = drinkNum
        self._waveOffset = waveOffset
    }
    
    var body: some View {
        ZStack{
            WaveWithHeight(drinkNum: $drinkNum, waveOffset: $waveOffset)
        }
    }
}

struct WaveWithHeight: View {
    @Binding var drinkNum: Double
    @Binding var waveOffset: Angle
    
    @Environment(\.modelContext) var modelContext
    @State var cupCapacity: Double = 1000.0
    
    var body : some View {
        GeometryReader { geometry in
            ZStack {
                Wave(offSet: Angle(degrees: waveOffset.degrees + 270))
                    .fill(Color.blue)
                    .opacity(0.3)
                    .animation(.linear(duration: 2.3).repeatForever(autoreverses: false), value: waveOffset)
                
                Wave(offSet: Angle(degrees: waveOffset.degrees + 90))
                    .fill(Color.blue)
                    .opacity(0.4)
                    .animation(.linear(duration: 1.8).repeatForever(autoreverses: false), value: waveOffset)
                
                Wave(offSet: Angle(degrees: waveOffset.degrees))
                    .fill(Color.blue)
                    .onAppear {
                        waveOffset = waveOffset + Angle(degrees: 360)
                    }
                    .animation(.linear(duration: 1.7).repeatForever(autoreverses: false), value: waveOffset)
            }
            .animation(.linear(duration: 0.3), value: drinkNum)
            .offset(x:0, y: geometry.size.height * (1.0 - drinkNum / self.cupCapacity))
            .frame(width: geometry.size.width, height: geometry.size.height)
        }.onAppear() {
            let config = getWaterTracerConfiguration(modelContext: modelContext)
            withAnimation(.linear(duration: 0.2)) {
                self.cupCapacity = getCupCapacity(config:config)
            }
        }
    }
}

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double = 100
    
    public mutating func set_offSet(_ offSet: Angle) {
        self.offSet = offSet
    }
    
    var animatableData: Double {
        get { offSet.degrees }
        set {
            offSet = Angle(degrees: newValue)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height
        let yOffSet = CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10)
        
        p.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()
        
        return p
    }
}


#Preview {
    @Previewable @State var drinkNum: Double = 100.0
    @Previewable @State var waveOffset: Angle = Angle(degrees: 0.0)
    ZStack {
        WaveAnimation($drinkNum, $waveOffset)
        InvisibleSlider(drinkNum: $drinkNum, waveOffset: $waveOffset)
        Text("\(drinkNum)ml")
    }
}
