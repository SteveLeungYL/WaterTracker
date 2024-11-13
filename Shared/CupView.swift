//
//  MyIcon.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/27/24.
//

import SwiftUI

struct CupView: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(\.scenePhase) var scenePhase
    
    // FIXME:: Animation glitches.
    // The waveOffset is necessary as a State here.
    // If move the waveOffset into waveAnimation, the start
    // position of the waveOffset will cause problem of the animation.
    @State private var waveOffset: Angle = .zero
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    private var crossOsConnectivity: CrossOsConnectivity = CrossOsConnectivity.shared
    
    @Environment(WaterTracerConfigManager.self) private var config
    @Environment(\.modelContext) var modelContext
    
    @State private var textStr: LocalizedStringKey = "100 ml"
    @State private var unitStr: String = "ml"
    
    @State var hapticTrigger = false
    @State var isDrinkButtonExpanded: Bool = false
    
    @State var updateToggle: Bool = false
    
    func setDefaultDrinkNum() {
        self.healthKitManager.drinkNum = Double(Int(config.getCupCapacity() * 3 / 4))
    }
    
    func updateTextStr() {
        self.unitStr = config.getUnitStr()
        if config.waterUnit == .ml {
            let drinkNumStr = String(format: "%.3d", Int(self.healthKitManager.drinkNum))
            self.textStr = LocalizedStringKey("\(drinkNumStr)\(self.unitStr)")
        } else {
            let drinkNumStr = String(format: "%.1f", self.healthKitManager.drinkNum)
            self.textStr = LocalizedStringKey("\(drinkNumStr)\(self.unitStr)")
        }
    }
    
    var body : some View {
        
        NavigationStack {
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top, endPoint: .bottom)
                    .clipped()
                    .ignoresSafeArea(.all) // As background.
                GeometryReader { geometry in
                    @State var cupWidth = geometry.size.width * 0.8
                    VStack{
                        Spacer()
                        HStack{
                            
                            Spacer()
                            ZStack{
                                
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
                                        InvisibleSlider()
                                    )
                                
                            }
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack{
                            if #available(watchOS 11.0, *) {
                                /*
                                 * FIXME:: HELP!!!!!!
                                 * This is super ugly but I don't know another way around it.
                                 * THE ONLY DIFFERENCE IS THE .handGestureShortcut(.primaryAction) in watchOS.
                                 */
                                Button{
                                    Task {
                                        if let alertError = await healthKitManager.saveDrinkWater(drink_num: self.healthKitManager.drinkNum, waterUnitInput: config.waterUnit) {
                                            self.alertError = alertError
                                            self.isShowAlert = true
                                        }
                                        LocalNotificationHandler.registerLocalNotification()
                                        CrossOsConnectivity.shared.sendNotificationReminder()
                                        self.isDrinkButtonExpanded = true
                                        self.textStr = "Water + "
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.isDrinkButtonExpanded = false
                                        }
                                        updateToggle.toggle()
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
                                .frame(width: 70, height: 70, alignment: .center)
#else
                                .handGestureShortcut(.primaryAction)
#endif
                                .background(.regularMaterial)
                                .clipShape(.circle)
                                .scaleEffect(isDrinkButtonExpanded ? 2.5 : 1)
                                .animation(Animation.easeOut(duration: 0.3), value: self.isDrinkButtonExpanded)
                                // Well, sensoryFeedback is not working. :-(
                                .sensoryFeedback(
                                    .impact(weight: .medium, intensity: 0.9),
                                    trigger: hapticTrigger
                                )
                                .alert(isPresented: $isShowAlert, error: alertError) { _ in
                                    Button("OK", role:.cancel) {}
                                } message: { error in
                                    Text(error.recoverySuggestion ?? "Try again later.")
                                }
                            } else {
                                // Fallback on earlier versions
                                /*
                                 * FIXME:: HELP!!!!!!
                                 * The whole thing repeats again without .handGestureShortcut(.primaryAction)
                                 * That's the only difference.
                                 */
                                Button{
                                    Task {
                                        if let alertError = await healthKitManager.saveDrinkWater(drink_num: self.healthKitManager.drinkNum, waterUnitInput: config.waterUnit) {
                                            self.alertError = alertError
                                            self.isShowAlert = true
                                        }
                                        LocalNotificationHandler.registerLocalNotification()
                                        CrossOsConnectivity.shared.sendNotificationReminder()
                                        self.isDrinkButtonExpanded = true
                                        self.textStr = "Water + "
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            self.isDrinkButtonExpanded = false
                                        }
                                        updateToggle.toggle()
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
                                .frame(width: 70, height: 70, alignment: .center)
#endif
                                .background(.regularMaterial)
                                .clipShape(.circle)
                                .scaleEffect(isDrinkButtonExpanded ? 2.5 : 1)
                                .animation(Animation.easeOut(duration: 0.3), value: self.isDrinkButtonExpanded)
                                // Well, sensoryFeedback is not working. :-(
                                .sensoryFeedback(
                                    .impact(weight: .medium, intensity: 0.9),
                                    trigger: hapticTrigger
                                )
                                .alert(isPresented: $isShowAlert, error: alertError) { _ in
                                    Button("OK", role:.cancel) {}
                                } message: { error in
                                    Text(error.recoverySuggestion ?? "Try again later.")
                                }
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
                            
                            NavigationLink(destination: SummaryView() ) {
                                HStack{
                                    Spacer(minLength: 0)
                                    VStack{
                                        Spacer(minLength: 0)
                                        CircularProgressView(config: self.config, updateToggle: self.$updateToggle)
                                        Spacer(minLength: 0)
                                    }
                                    Spacer(minLength: 0)
                                }
                            }
#if !os(watchOS)
                            .padding()
                            .frame(width: 70, height: 70, alignment: .center)
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
                        // If the user change the daily goal, update the circular progress bar when this view onAppear.
                        // Might be duplicated with the onChange(of: scenePhase), but should be fine to call it multiple times.
                        self.updateToggle.toggle()
                    }
                    .onChange(of: self.healthKitManager.drinkNum) {
                        updateTextStr()
                    }
                    .onChange(of: scenePhase) {
                        // When re-enter the app, refresh the
                        // circular progress bar.
                        oldPhase, newPhase in
                        if newPhase == .active {
                            // Toggle circular bar updates. 
                            self.updateToggle.toggle()
                        }
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
