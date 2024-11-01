//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct CupView: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    
    @State private var waveOffset: Angle = .zero
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    @Environment(WaterTracerConfigManager.self) private var config
    @Environment(\.modelContext) var modelContext
    
    @State private var textStr: String = "100 ml"
    @State private var unitStr: String = "ml"
    
    @State var hapticTrigger = false
    
    func setDefaultDrinkNum() {
        self.healthKitManager.drinkNum = Double(Int(config.getCupCapacity() * 3 / 4))
    }
    
    func updateTextStr() {
        self.unitStr = config.getUnitStr()
        if config.waterUnit == .ml {
            self.textStr = String(format: "%3d\(self.unitStr)", Int(self.healthKitManager.drinkNum))
        } else {
            self.textStr = String(format: "%.1f\(self.unitStr)", self.healthKitManager.drinkNum)
        }
    }
    
    var body : some View {
        
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top, endPoint: .bottom)
                    .clipped()
                    .ignoresSafeArea(.all) // As background.
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
                                        WaveAnimation($waveOffset, true)
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
                                        InvisibleSlider(waveOffset: $waveOffset)
                                    )
                                
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack{
                            Button{
                                Task {
                                    if let alertError = await healthKitManager.saveDrinkWater(drink_num: self.healthKitManager.drinkNum, waterUnitInput: config.waterUnit) {
                                        self.alertError = alertError
                                        self.isShowAlert = true
                                    }
                                    NotificationHandler.registerLocalNotification()
                                    // DEBUG
                                    //                            healthKitManager.readDrinkWater()
                                }
#if os(watchOS)
                                WKInterfaceDevice.current().play(.success)
#endif
                                
                                
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
                            .sensoryFeedback(
                                .impact(weight: .medium, intensity: 0.9),
                                trigger: hapticTrigger
                            )
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
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            NavigationLink(destination: RingView() ) {
                                Image(systemName: "ellipsis.circle")
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
                        config.updateWaterTracerConfig(modelContext: self.modelContext)
                        setDefaultDrinkNum()
                        updateTextStr()
                        // HERE, make sure the animation plays correctly by reset the original value.
                        self.waveOffset = .zero
                    }
                    .onChange(of: self.healthKitManager.drinkNum) {
                        updateTextStr()
                    }
                }
            }
        }
        .accentColor(.black)
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    CupView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .environment(healthKitManager)
        .environment(configManager)
}
