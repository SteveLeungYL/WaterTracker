//
//  AppIntent.swift
//  WaterTracker Watch Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import AppIntents

enum WidgetDataRange: String, AppEnum {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Pocket Water Tracker Summary View"
    
    static var caseDisplayRepresentations: [WidgetDataRange : DisplayRepresentation] = [
        .hour: DisplayRepresentation(stringLiteral: "Day View"),
        .week: DisplayRepresentation(stringLiteral: "Week View"),
    ]
    
    case hour = "Day View"
    case week = "Week View"
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Data Range" }
    static var description: IntentDescription { "Showing 24 hours day view or week view" }

    // An example configurable parameter.
    @Parameter(title: "Choose Water Tracker Summary View", default: .hour)
    var chosenView: WidgetDataRange
}
