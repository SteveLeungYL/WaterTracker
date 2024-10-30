//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct CupView: View {
    
    @StateObject var healthKitManager: HealthKitManager = HealthKitManager.shared

    @State private var percent: Double = 20
    @State private var waveOffset = Angle(degrees: 0)
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
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
                        #if !os(watchOS)
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 8))
                        #else
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 5))
                        #endif

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
                
                HStack{
                    Button{
                        if let alertError = healthKitManager.saveDrinkWater(drink_num: percent) {
                            self.alertError = alertError
                            self.isShowAlert = true
                        } else {
                            self.alertError = HealthKitError.healthKitNotAvailable
                            self.isShowAlert = true
                        }
                    } label: {
                        Image(systemName: "mouth.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                    }
                    #if !os(watchOS)
                    .padding()
                    #endif
                    .background(.regularMaterial)
                    .clipShape(.circle)
                    .alert(isPresented: $isShowAlert, error: alertError) { _ in
                        Button("OK", role:.cancel) {}
                        } message: { error in
                          Text(error.recoverySuggestion ?? "Try again later.")
                        }
                    
                    Spacer()
                    
                    Button{
                        // TODO::
                        // Do something here.
                    } label: {
                        Text("Ring")
                            .font(.title3)
                    }
                    #if !os(watchOS)
                    .padding()
                    #endif
                    .background(.regularMaterial)
                    .clipShape(.circle)
                    
                }
                .padding(.horizontal)
                #if !os(watchOS)
                .padding(.vertical) // give the small watch screen a break!
                #endif

            } // From the VStack. This should expand to the whole screen excluding the safe area
            
        }
    }
}

#Preview {
    CupView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
}
