//
//  WeightDiffBarChart.swift
//  WaterTracer
//
//  Modified by Yu Liang on 10/31/24.
//

//
//  WeightDiffBarChart.swift
//  ahowCaseHealthKit
//
//  Created by Arthur Nsereko Kahwa on 5/28/24.
//

import SwiftUI
import Charts

struct WeightDiffBarChart: View {
    var chartData: [HealthMetric]
    
    @State private var rawSelectedDate: Date?
    @Environment(WaterTracerConfigManager.self) private var config
    
    var selectedData: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        VStack { // Overall chart card
            HStack {
                VStack(alignment: .leading) {
                    Label("Water Tracer", systemImage: "drop.fill")
                        .font(.title3.bold())
                        .foregroundStyle(.blue)
                    
                    Text("Showing weekly data")
                        .font(.caption)
                }
                
                Spacer()
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let selectedData {
                    RuleMark(x: .value("Selected Data", selectedData.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.4))
                        .offset(y: -12)
                        .annotation(position: .top,
                                    spacing: 0,
                                    overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                            annotationView
                        }
                }
                
                ForEach(chartData) { curDateTracer in
                    BarMark(x: .value("Date", curDateTracer.date, unit: .day),
                            y: .value("Water Drink", curDateTracer.value)
                    )
                    .foregroundStyle(curDateTracer.value >= self.config.getDailyGoal() ? Color.blue.gradient : Color.mint.gradient)                }
            }
            .frame(height: 150)
            .chartXSelection(value: $rawSelectedDate.animation(.easeIn))
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisValueLabel(format: .dateTime.weekday(), centered: true)
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
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.regularMaterial))
    }
    
    var annotationView: some View {
        VStack(alignment: .leading) {
            Text(selectedData?.date ?? .now, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            
            Text(selectedData?.value ?? 0, format: .number.precision(.fractionLength(2)))
                .fontWeight(.heavy)
                .foregroundStyle((selectedData?.value ?? 0) >= 0 ? .indigo : .mint)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.regularMaterial)
                .shadow(color: .secondary.opacity(0.3), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
//    WeightDiffBarChart(chartData: MockData.weightDiffs)
}
