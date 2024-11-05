//
//  RingView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftUI
import Charts

struct RingView: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config
    @Environment(\.scenePhase) var scenePhase
    
    @State private var waveOffset = Angle(degrees: 0)
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    @State private var textStr: String = "100 ml"
    @State private var unitStr: String = "ml"
    
    @State var updateToggle: Bool = false
    
    func updateTextStr() {
        self.unitStr = config.getUnitStr()
        if config.waterUnit == .ml {
            self.textStr = String(format: "Today you drink \n%3d\(self.unitStr) out of the suggested %3d\(self.unitStr), %3d\(self.unitStr) to go", Int(self.healthKitManager.todayTotalDrinkNum), Int(self.config.getDailyGoal()), max(0, Int(self.config.getDailyGoal() - self.healthKitManager.todayTotalDrinkNum)))
        } else {
            self.textStr = String(format: "Today you drink \n%.1f\(self.unitStr) out of the suggested %.1f\(self.unitStr), %.1f\(self.unitStr) to go", self.healthKitManager.todayTotalDrinkNum, self.config.getDailyGoal(), max(0.0, self.config.getDailyGoal() - self.healthKitManager.todayTotalDrinkNum))
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
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkDayData, dateComponents: .hour, mainTitle: "Day Tracer", subTitle: "Showing 24 hours data", config: self.config)
                            .padding()
                            .onAppear() {
                                Task{
                                    await self.healthKitManager.updateDrinkWaterDay(waterUnitInput: self.config.waterUnit)
                                }
                            }
                        
                        WaterTracingBarChart(chartData: self.healthKitManager.drinkWeekData, dateComponents: .day, mainTitle: "Week Tracer", subTitle: "Showing last 7 days data", config: self.config)
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
                }
                .onChange(of: healthKitManager.todayTotalDrinkNum) {
                    // For reloading purpose
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
