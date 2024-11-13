//
//  WaterTracker_WidgetBundle.swift
//  WaterTracker Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import SwiftUI

@main
struct WaterTracker_WidgetBundle: WidgetBundle {
    var body: some Widget {
        WaterTracker_Widget()
        WaterTracker_Accessory_Widget()
    }
}
