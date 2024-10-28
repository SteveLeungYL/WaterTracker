//
//  InvisibleSlider.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/28/24.
//

import SwiftUI

struct InvisibleSlider: View {
    
    @Binding var percent: Double
    var percent_choices: [Double] = stride(from: 0.0, through: 100, by: 5).map(\.self)
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Picker("Invisible Picker", selection: $percent) {
                    ForEach(percent_choices, id: \.self) {cur_value in
                        Text(String(format: "%f", cur_value))
                    }
                }
                .pickerStyle(.wheel)
                .clipped()
                .frame(height: geo.size.height)
            }.frame(height: geo.size.height)
        }
        
    }
}

#Preview {
    @Previewable @State var percent: Double = 20
    InvisibleSlider(percent: $percent)
}
