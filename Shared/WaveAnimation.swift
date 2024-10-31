//
//  WaveAnimation.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//  Copied by Yu Liang from https://github.com/RedDragonJ/Swift-Learning/tree/main/Animations/Animations/Animations
//  Created by James Layton on 8/7/23.

import SwiftUI

struct WaveAnimation: View {
    
    @Binding var waveOffset: Angle
    var isCup: Bool
    
    init(_ waveOffset: Binding<Angle>, _ isCup: Bool) {
        self._waveOffset = waveOffset
        self.isCup = isCup
    }
    
    var body: some View {
        ZStack{
            WaveWithHeight(waveOffset: $waveOffset, isCup: isCup)
        }
    }
}

struct WaveWithHeight: View {
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config
    @Binding var waveOffset: Angle
    
    @State var drinkNum: Double = 0.0
    
    var isCup: Bool // TODO:: FIXME:: Better implementation?
    
    // Use for animation and default value scaling.
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
            .animation(.linear(duration: 0.3), value: self.healthKitManager.drinkNum)
            .offset(x:0, y: geometry.size.height * (1.0 - self.healthKitManager.drinkNum / self.cupCapacity))
            .frame(width: geometry.size.width, height: geometry.size.height)
        }.onAppear() {
            withAnimation(.linear(duration: 0.2)) {
                if self.isCup {
                    self.cupCapacity = config.cupCapacity
                    self.drinkNum = healthKitManager.drinkNum
                } else {
                    self.cupCapacity = config.getDailyGoal()
                    self.drinkNum = config.getDailyGoal()
                }
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
    @Previewable @State var waveOffset: Angle = Angle(degrees: 0.0)
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    ZStack {
        WaveAnimation($waveOffset, true)
        InvisibleSlider(waveOffset: $waveOffset)
    }
    .modelContainer(sharedWaterTracerModelContainer)
    .environment(healthKitManager)
    .environment(configManager)
}
