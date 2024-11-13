//
//  RingView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftUI
import Charts

struct RingView: View {
    /* Not used in widgets, thus fine for environment variables. */
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config
    @Environment(\.scenePhase) var scenePhase
    
    // FIXME:: Animation glitches.
    // The waveOffset is necessary as a State here.
    // If move the waveOffset into waveAnimation, the start
    // position of the waveOffset will cause problem of the animation.
    @State private var waveOffset = Angle(degrees: 0)
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    // Placeholder for texts.
    @State private var textStr: LocalizedStringKey = "100 ml"
    @State private var unitStr: String = "ml"
    
    // For updating all UIs when configuration changes.
    @State var updateToggle: Bool = false
    
    func updateTextStr() {
        self.unitStr = config.getUnitStr()
        if config.waterUnit == .ml {
            let drinkNumStr = String(format: "%d", Int(self.healthKitManager.todayTotalDrinkNum))
            let suggestedNumStr = String(format: "%d", Int(self.config.getDailyGoal()))
            let leftNumStr = String(format: "%d", Int(max(0, Int(self.config.getDailyGoal() - self.healthKitManager.todayTotalDrinkNum))))
            
            // Always use main thread to update UI.
            DispatchQueue.main.async{
                self.textStr = LocalizedStringKey("Today you drink \(drinkNumStr)\(self.unitStr) out of the goal \(suggestedNumStr)\(self.unitStr), \(leftNumStr)\(self.unitStr) to go")
            }
        } else {
            
            let drinkNumStr = String(format: "%.1f", self.healthKitManager.todayTotalDrinkNum)
            let suggestedNumStr = String(format: "%.1f", self.config.getDailyGoal())
            let leftNumStr = String(format: "%.1f", max(0.0, self.config.getDailyGoal() - self.healthKitManager.todayTotalDrinkNum))
            
            // Always use main thread to update UI.
            DispatchQueue.main.async{
                self.textStr = LocalizedStringKey("Today you drink \(drinkNumStr)\(self.unitStr) out of the goal \(suggestedNumStr)\(self.unitStr), \(leftNumStr)\(self.unitStr) to go")
            }
        }
    }
    
    func updateEverything() async {
        // Update everything.
        // No need to update config here, because it is binding
        // directly to the unit picker.
        if let err = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit) {
            self.alertError = err
            self.isShowAlert = true
        }
        _ = await self.healthKitManager.updateDrinkWaterDay(waterUnitInput: self.config.waterUnit)
        _ = await self.healthKitManager.updateDrinkWaterWeek(waterUnitInput: self.config.waterUnit)
        updateTextStr()
    }
    
    var body : some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top, endPoint: .bottom)
                .clipped()
                .ignoresSafeArea(.all) // As background.
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
                                        WaveAnimation($waveOffset, false)
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
                                    .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
#endif
                                
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: bodyWidth, alignment: .center)
                            }
                            Spacer()
                        }
                        VStack{
                            Spacer()
                            HStack{
                                Text(self.textStr)
                                    .font(.title)
                                    .minimumScaleFactor(0.00001)
                                    .foregroundStyle(.black)
                                    .fontWeight(.bold)
                                    .frame(height: geometry.size.width * 0.30, alignment: .center)
                                    .allowsHitTesting(false)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            Spacer()
                        }
                        Spacer()
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkDayData, dateComponents: .hour, mainTitle: LocalizedStringKey("Day Water Tracer"), subTitle: LocalizedStringKey("Showing 24 hours data"), config: self.config)
                            .padding()
                            .onAppear() {
                                Task{
                                    await self.healthKitManager.updateDrinkWaterDay(waterUnitInput: self.config.waterUnit)
                                }
                            }
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkWeekData, dateComponents: .day, mainTitle: LocalizedStringKey("Week Water Tracer"), subTitle: LocalizedStringKey("Showing last 7 days data"), config: self.config)
                            .padding()
                            .onAppear() {
                                Task{
                                    await self.healthKitManager.updateDrinkWaterWeek(waterUnitInput: self.config.waterUnit)
                                }
                            }
                        
                        Spacer()
                        
                        UnitPickerView(updateToggle: $updateToggle)
                            .padding()
                        
                    }
                    #if os(iOS)
                    Text("[1] Cleveland Clinic. (2024, October 3). How much water you should drink every day. https://health.clevelandclinic.org/how-much-water-do-you-need-daily")
                        .font(.system(size: 8))
                        .foregroundStyle(.black)
                        .padding()
                    #endif
                } // scrollView
                .onAppear {
                    if let err = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit) {
                        self.alertError = err
                        self.isShowAlert = true
                    }
                    // For reloading purpose
                    updateTextStr()
                    // Reset the animation starting point.
                    // If not set, could lead to animation glitches.
                    self.waveOffset = .zero
                }
                .onChange(of: healthKitManager.todayTotalDrinkNum) {
                    // Reloading text.
                    updateTextStr()
                }
                .onChange(of: self.updateToggle) {
                    Task{
                        await self.updateEverything()
                    }
                }
                .onChange(of: self.scenePhase) {
                    oldPhase, newPhase in
                    if newPhase == .active {
                        // Refresh the page when the app goes to the foreground.
                        Task{
                            await self.updateEverything()
                        }
                    }
                }
                .alert(isPresented: $isShowAlert, error: alertError) { _ in
                    Button("OK", role:.cancel) {}
                } message: { error in
                    Text(error.recoverySuggestion ?? "Try again later.")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTracerConfigManager()
    RingView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .environment(healthKitManager)
        .environment(configManager)
}
