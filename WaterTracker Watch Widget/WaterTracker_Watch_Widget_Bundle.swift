//
//  WaterTracker_Watch_Widget_Bundle.swift
//  WaterTracker
//
//  Created by Yu Liang on 11/5/24.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct WaterTracker_Watch_Widget_Bundle: WidgetBundle {
    var body: some Widget {
        WaterTracker_Watch_Widget(isDayView: true, kind: "WatchWidget_Day_View")
        WaterTracker_Watch_Widget(isDayView: false, kind: "WatchWidget_Week_View")
        WaterTracker_Accessory_Widget()
    }
}
