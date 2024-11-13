//
//  WeightDiffBarChart.swift
//  WaterTracker
//
//  Modified by Yu Liang on 10/31/24.
//
//  Originally Created by Arthur Nsereko Kahwa on 5/28/24.
//  Link: git@github.com:arthurkahwa/healthkit_showcase.git
//

import SwiftUI
import Charts

struct WaterTracingBarChart: View {
    var chartData: [HealthMetric]
    @State var dateComponents: Calendar.Component
    @State var mainTitle: LocalizedStringKey
    @State var subTitle: LocalizedStringKey
    
    #if WIDGET
    // iOS widget.
    @State var hourGap: Int = 4
    #elseif WATCH_WIDGET || os(watchOS)
    // watchOS or watchOS widget.
    // the font is bigger because we skipped some titles.
    @State var hourGap: Int = 6
    #else
    // In App.
    @State var hourGap: Int = 4
    #endif

    //    @State private var rawSelectedDate: Date?
    @State var config: WaterTrackerConfigManager
    
    //    var selectedData: HealthMetric? {
    //        guard let rawSelectedDate else { return nil }
    //
    //        return chartData.first {
    //            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
    //        }
    //    }
    
    var body: some View {
        VStack { // Overall chart card
            #if !WIDGET && !WATCH_WIDGET
            HStack {
                VStack(alignment: .leading) {
                    Text(mainTitle)
                        .font(.title3.bold())
                        .foregroundStyle(.blue)
                    
                    Text(subTitle)
                        .font(.caption)
                }
                
                Spacer()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            #elseif WIDGET
            // This is widget rending mode.
            VStack{
                HStack{
                    Text(mainTitle)
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                    Spacer()
                }
                HStack{
                    HStack{
                        Text(subTitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    Spacer()
                }
            }
            #elseif WATCH_WIDGET
            // This is watch widget rending mode.
            VStack{
                HStack{
                    HStack{
                        Text(subTitle)
                            .font(.caption)
                        Spacer()
                    }
                    Spacer()
                }
            }
            #endif
            
            Chart {
                //                if let selectedData {
                //                    RuleMark(x: .value("Selected Data", selectedData.date, unit: .day))
                //                        .foregroundStyle(Color.secondary.opacity(0.4))
                //                        .offset(y: -12)
                //                        .annotation(position: .top,
                //                                    spacing: 0,
                //                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                //                            annotationView
                //                        }
                //                }
                if self.dateComponents == .day {
                    ForEach(chartData) { curDateTracker in
                        BarMark(x: .value("Day", curDateTracker.date, unit: .day),
                                y: .value("Water Drink", curDateTracker.value)
                        )
                        .foregroundStyle(curDateTracker.value >= self.config.getDailyGoal() ? Color.blue.gradient : Color.mint.gradient)
                    }
                } else if self.dateComponents == .hour {
                    ForEach(chartData) { curDateTracker in
                        BarMark(x: .value("Hour", curDateTracker.date, unit: .hour),
                                y: .value("Water Drink", curDateTracker.value)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                }
            }
            #if !WIDGET && !WATCH_WIDGET
            .frame(height: 150)
            #endif
            //            .chartXSelection(value: $rawSelectedDate.animation(.easeIn))
            .chartXAxis {
                if self.dateComponents == .day {
                    #if !os(watchOS)
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    }
                    #else
                    // Use .short formatting for weekday on watchOS.
                    // The default formatting is too big for Apple Watch SE (40mm).
                    AxisMarks(values: .stride(by: .day)) {
                        AxisValueLabel(format: Date.FormatStyle().weekday(.short), centered: true)
                    }
                    #endif
                } else {
                    AxisMarks(values: .stride(by: .hour, count: self.hourGap)) { value in
                        if let date = value.as(Date.self) {
                            let hour = Calendar.current.component(.hour, from: date)
                            switch hour {
                            case 0, 12:
                                AxisValueLabel(format: .dateTime.hour())
                            default:
                                AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                            }
                            
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(Color.secondary.opacity(0.4))
                    
                    AxisValueLabel()
                }
            }
        }
        #if !WIDGET && !WATCH_WIDGET
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.regularMaterial))
        #endif
    }
    
    //    var annotationView: some View {
    //        VStack(alignment: .leading) {
    //            Text(selectedData?.date ?? .now, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
    //                .font(.footnote.bold())
    //                .foregroundStyle(.secondary)
    //
    //            Text(selectedData?.value ?? 0, format: .number.precision(.fractionLength(2)))
    //                .fontWeight(.heavy)
    //                .foregroundStyle(.blue.gradient)
    //        }
    //        .padding(12)
    //        .background(
    //            RoundedRectangle(cornerRadius: 4)
    //                .fill(.regularMaterial)
    //                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
    //        )
    //    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @State var configManager = WaterTrackerConfigManager()
    
    // Random week data for Preview. 
    @Previewable @State var mockChartData: [HealthMetric] = fillEmptyData(drinkDataRaw: [], startDate: NSCalendar.current.date(byAdding: .day, value: -7, to: getStartOfDate(date: Date()))!, endDate:getStartOfDate(date: Date()), gapUnit: .day, isMock: true)
    
    ZStack {
        WaterTracingBarChart(chartData: mockChartData, dateComponents: .day, mainTitle: "Week Tracker", subTitle: "Showing last 7 days data", config: WaterTrackerConfigManager())
            .modelContainer(sharedWaterTrackerModelContainer)
            .environment(healthKitManager)
            .environment(configManager)
    }
}
