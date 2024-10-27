//
//  WaveAnimation.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//  Copied by Yu Liang from https://github.com/RedDragonJ/Swift-Learning/tree/main/Animations/Animations/Animations
//  Created by James Layton on 8/7/23.

import SwiftUI

struct WaveAnimation: View {
    
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            
            Wave(offSet: Angle(degrees: waveOffset.degrees + 270), percent: percent)
                .fill(Color.blue)
                .opacity(0.3)
                .animation(.linear(duration: 2.3).repeatForever(autoreverses: false), value: UUID())
                .ignoresSafeArea(.all)

            Wave(offSet: Angle(degrees: waveOffset.degrees + 90), percent: percent)
                .fill(Color.blue)
                .opacity(0.4)
                .animation(.linear(duration: 1.8).repeatForever(autoreverses: false), value: UUID())
                .ignoresSafeArea(.all)

            Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
                .fill(Color.blue)
                .animation(.linear(duration: 1.7).repeatForever(autoreverses: false), value: UUID())
                .ignoresSafeArea(.all)
            
            Text("\(Int(percent))%")
                .font(.system(size: 70))
                .fontWeight(.bold)
            
            InvisibleSlider(percent: $percent)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
}

struct Wave: Shape {
    
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
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

struct InvisibleSlider: View {
    
    @Binding var percent: Double
    
    var body: some View {
        GeometryReader { geo in
            let dragGesture = DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let percent = 1.0 - Double(value.location.y / geo.size.height)
                    self.percent = max(0, min(100, percent * 100))
                }
            
            Rectangle()
                .opacity(0.00001) // The super small value will effectively hide the slider. 
                .frame(width: geo.size.width, height: geo.size.height)
                .gesture(dragGesture)
        }
    }
}

#Preview {
    WaveAnimation()
}
