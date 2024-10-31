//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct CupView: View {
    
    @StateObject var healthKitManager: HealthKitManager = HealthKitManager.shared

    @State private var drinkNum: Double = 250.0 // default 100 ml
    @State private var waveOffset = Angle(degrees: 0)
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    @Environment(\.modelContext) var modelContext
    @State private var config: WaterTracerConfiguration = .init()
    @State private var textStr: String = "100 ml"
    @State private var unitStr: String = "ml"
    
    func setDefaultDrinkNum() {
        self.config = getWaterTracerConfiguration(modelContext: modelContext)
        let cupCapacity = getCupCapacity(config: config)
        self.drinkNum = Double(Int(cupCapacity * 3 / 4))
    }
    
    func updateTextStr() {
        self.config = getWaterTracerConfiguration(modelContext: modelContext)
        self.unitStr = getUnitStr(config: self.config)
        if config.waterUnit == .ml {
            self.textStr = String(format: "%3d\(self.unitStr)", Int(self.drinkNum))
        } else {
            self.textStr = String(format: "%.2f\(self.unitStr)", self.drinkNum)
        }
    }

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
                                WaveAnimation($drinkNum, $waveOffset, true)
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
                                InvisibleSlider(drinkNum: $drinkNum, waveOffset: $waveOffset)
                            )
                        
                    }
                    Spacer()
                }
                
                Spacer()
                
                HStack{
                    Button{
                        Task {
                            if let alertError = await healthKitManager.saveDrinkWater(drink_num: drinkNum, config: config) {
                                self.alertError = alertError
                                self.isShowAlert = true
                            }
                            NotificationHandler.registerLocalNotification()
                            // DEBUG
//                            healthKitManager.readDrinkWater()
                        }
                    } label: {
                        Image(systemName: "mouth.fill")
                            .foregroundStyle(.red)
                            .font(.body)
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
                    
                    Text(self.textStr)
                        .font(.system(size: 300))
                        .minimumScaleFactor(0.00001)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .frame(height: geometry.size.width * 0.30, alignment: .center)
                        .allowsHitTesting(false)
                    
                    Spacer()
                    
                    Button{
                        // TODO::
                        // Do something here.
                    } label: {
                        Text("Ring")
                            .font(.body)
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
            .onAppear() {
                setDefaultDrinkNum()
                updateTextStr()
            }
            .onChange(of: self.drinkNum) {
                updateTextStr()
            }
        }
    }
}

#Preview {
    CupView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
}
