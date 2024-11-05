//
//  AppIntent.swift
//  WaterTracer Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Dummy App Intent" }
    static var description: IntentDescription { "Stay tuned for the App Intent feature. " }

    // An example configurable parameter.
    @Parameter(title: "Stay tuned for the App Intent", default: "😃")
    var favoriteEmoji: String
}
