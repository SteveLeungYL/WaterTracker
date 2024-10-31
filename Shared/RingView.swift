//
//  RingView.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

import SwiftUI

struct RingView: View {
    
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(WaterTracerConfigManager.self) private var config
    
    @State private var waveOffset = Angle(degrees: 0)
    
    @State private var isShowAlert: Bool = false
    @State private var alertError: HealthKitError? = nil
    
    @State private var textStr: String = "100 ml"
    @State private var unitStr: String = "ml"
    
    func updateTextStr() {
        self.unitStr = config.getUnitStr()
        if config.waterUnit == .ml {
            self.textStr = String(format: "Today you drink \n%3d\(self.unitStr) / %3d\(self.unitStr)", Int(self.healthKitManager.todayTotalDrinkNum), Int(self.config.getDailyGoal()))
        } else {
            self.textStr = String(format: "Today you drink \n%.1f\(self.unitStr) / %.1f\(self.unitStr)", Int(self.healthKitManager.todayTotalDrinkNum), Int(self.config.getDailyGoal()))
        }
    }
    
    var body : some View {
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
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 5))
#endif
                            
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bodyWidth, alignment: .center)
                        }
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        Text(self.textStr)
                            .font(.title)
                            .minimumScaleFactor(0.00001)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .frame(height: geometry.size.width * 0.30, alignment: .center)
                            .allowsHitTesting(false)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    Spacer()
                }
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
        .alert(isPresented: $isShowAlert, error: alertError) { _ in
            Button("OK", role:.cancel) {}
            } message: { error in
              Text(error.recoverySuggestion ?? "Try again later.")
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
