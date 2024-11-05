//
//  WaterTracer_Watch_Widget_Bundle.swift
//  WaterTracer
//
//  Created by Yu Liang on 11/5/24.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct WaterTracer_Watch_Widget_Bundle: WidgetBundle {
    var body: some Widget {
        WaterTracer_Watch_Widget(isDayView: true, kind: "WatchWidget_Day_View")
        WaterTracer_Watch_Widget(isDayView: false, kind: "WatchWidget_Week_View")
    }
}
