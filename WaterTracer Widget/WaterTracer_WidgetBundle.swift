//
//  WaterTracer_WidgetBundle.swift
//  WaterTracer Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import SwiftUI

@main
struct WaterTracer_WidgetBundle: WidgetBundle {
    var body: some Widget {
        WaterTracer_Widget()
        WaterTracer_Accessory_Widget()
    }
}
