//
//  WaveAnimation.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//  Copied by Yu Liang from https://github.com/RedDragonJ/Swift-Learning/tree/main/Animations/Animations/Animations
//  Created by James Layton on 8/7/23.

import SwiftUI

struct WaveAnimation: View {
    
    @Binding var percent: Double
    @Binding var waveOffset: Angle
    
    init(_ percent: Binding<Double>, _ waveOffset: Binding<Angle>) {
        self._percent = percent
        self._waveOffset = waveOffset
    }
    
    
    
    var body: some View {
        ZStack {
            
            Wave(offSet: Angle(degrees: waveOffset.degrees + 270), percent: percent)
                .fill(Color.blue)
                .opacity(0.3)
                .animation(.linear(duration: 2.3).repeatForever(autoreverses: false), value: waveOffset)
                .geometryGroup()
                .animation(.linear(duration: 0.3), value: percent)
            
            Wave(offSet: Angle(degrees: waveOffset.degrees + 90), percent: percent)
                .fill(Color.blue)
                .opacity(0.4)
                .animation(.linear(duration: 1.8).repeatForever(autoreverses: false), value: waveOffset)
                .geometryGroup()
                .animation(.linear(duration: 0.3), value: percent)
            
            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
                .fill(Color.blue)
                .onAppear {
                    waveOffset = waveOffset + Angle(degrees: 360)
                }
                .animation(.linear(duration: 1.7).repeatForever(autoreverses: false), value: waveOffset)
                .geometryGroup()
                .animation(.linear(duration: 0.3), value: percent)
        }
        
    }
}

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double
    
    public mutating func set_offSet(_ offSet: Angle) {
        self.offSet = offSet
    }
    
    var animatableData: AnimatablePair<Double, Double> {
        get { .init(offSet.degrees, percent) }
        set {
            offSet = Angle(degrees: newValue.first)
            percent = newValue.second
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
    @Previewable @State var percent: Double = 20
    @Previewable @State var waveOffset: Angle = Angle(degrees: 0.0)
    WaveAnimation($percent, $waveOffset)
}
