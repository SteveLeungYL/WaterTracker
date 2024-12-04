//
//  RingView.swift
//  WaterTracker
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftUI
import Charts

struct SummaryView: View {
    /* Not used in widgets, thus fine for environment variables. */
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTrackerConfigManager.self) private var config
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
    @State private var pctStr: String = "0%"
    
    // For updating all UIs when configuration changes.
    @State var updateToggle: Bool = false
    @State var CircularBarUpdateToggle: Bool = false
    
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
        
        DispatchQueue.main.async{
            var pct: Double = self.healthKitManager.todayTotalDrinkNum / self.config.getDailyGoal() * 100.0
            pct = min(100.0, max(pct, 0.0))
            self.pctStr = String(format: "%.0f%%", pct)
        }
    }
    
    func updateEverything() async {
        // Update everything.
        // No need to update config here, because it is binding
        // directly to the unit picker.
        if let err = healthKitManager.updateDrinkWaterToday(waterUnitInput: config.waterUnit) {
            DispatchQueue.main.async{
                self.alertError = err
                self.isShowAlert = true
            }
        }
        _ = await self.healthKitManager.updateDrinkWaterOneDay(waterUnitInput: self.config.waterUnit)
        _ = await self.healthKitManager.updateDrinkWaterWeek(waterUnitInput: self.config.waterUnit)
        updateTextStr()
        DispatchQueue.main.async{
            self.CircularBarUpdateToggle.toggle()
        }
    }
    
    var body : some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.cyan, .mint]), startPoint: .top, endPoint: .bottom)
                .clipped()
                .ignoresSafeArea(.all) // As background.
            GeometryReader { geometry in
#if os(iOS)
                @State var circularBarSize = geometry.size.width * 0.6
#elseif os(watchOS)
                @State var circularBarSize = geometry.size.width * 0.9
#endif
                ScrollView {
                    VStack{
//                        Spacer()
                        HStack{
                            Spacer()
                            ZStack{
#if os(iOS)
                                CircularProgressView(config: config, lineWidth: 20, updateToggle: $CircularBarUpdateToggle)
                                    .frame(width: circularBarSize, height: circularBarSize)
#elseif os(watchOS)
                                CircularProgressView(config: config, lineWidth: 8, updateToggle: $CircularBarUpdateToggle)
                                    .frame(width: circularBarSize, height: circularBarSize)
#endif
                                VStack{
                                    Text(pctStr)
                                        .font(.system(size: 400).bold())
                                        .foregroundStyle(.black)
                                        .minimumScaleFactor(0.01)
                                        .frame(height: circularBarSize * 0.2)
                                }
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
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkDayData, dateComponents: .hour, mainTitle: LocalizedStringKey("Day View"), subTitle: LocalizedStringKey("Showing 24 hours data"), config: self.config)
                            .padding()
                            .onAppear() {
                                Task{
                                    await self.healthKitManager.updateDrinkWaterOneDay(waterUnitInput: self.config.waterUnit)
                                }
                            }
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkWeekData, dateComponents: .day, mainTitle: LocalizedStringKey("Week View"), subTitle: LocalizedStringKey("Showing last 7 days data"), config: self.config)
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
                    HStack (alignment: .center) {
                        Image("Icon - Apple Health")
                            .resizable()
                            .frame(width: 32, height: 32)
                        Text("Save and Sync with Apple Health")
                            .foregroundStyle(.primary)
                            .foregroundStyle(.black)
                            .tint(.black)
#if !os(watchOS)
                            .font(.subheadline)
#else
                        // watchOS
                            .font(.caption)
                            .padding(.horizontal)
#endif
                    }
                    .padding()
#if os(iOS)
                    
                    VStack (alignment: .leading) {
                        Text("[1] Cleveland Clinic. (2024, October 3). How much water you should drink every day. https://health.clevelandclinic.org/how-much-water-do-you-need-daily")
                            .font(.system(size: 8))
                            .foregroundStyle(.black)
                            .tint(.black)
                            .padding(.horizontal)
                            .allowsHitTesting(false)
                        Text("[*] This application is open source at the following link: https://github.com/SteveLeungYL/WaterTracker. If you find it useful, please consider giving it a star! ❤️")
                            .font(.system(size: 8))
                            .foregroundStyle(.black)
                            .tint(.black)
                            .padding(.horizontal)
                            .allowsHitTesting(false)
                    }
                    Spacer()
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
                    
                    DispatchQueue.main.async{
                        // If not set, could lead to animation glitches.
                        self.waveOffset = .zero
                        self.CircularBarUpdateToggle.toggle()
                    }
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
    @Previewable @State var configManager = WaterTrackerConfigManager()
    SummaryView()
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .environment(healthKitManager)
        .environment(configManager)
}
