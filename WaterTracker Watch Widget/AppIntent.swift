//
//  AppIntent.swift
//  WaterTracker Watch Widget
//
//  Created by Yu Liang on 11/4/24.
//

import WidgetKit
import AppIntents

enum WidgetDataRange: String, AppEnum {
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Data Range"
    
    static var caseDisplayRepresentations: [WidgetDataRange : DisplayRepresentation] = [
        .hour: DisplayRepresentation(stringLiteral: "Hour View"),
        .week: DisplayRepresentation(stringLiteral: "Week View"),
    ]
    
    case hour = "Hour View"
    case week = "Week View"
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Data Range" }
    static var description: IntentDescription { "Showing 24 hour view or week view" }

    // An example configurable parameter.
    @Parameter(title: "Choose view", default: .hour)
    var chosenView: WidgetDataRange
}
