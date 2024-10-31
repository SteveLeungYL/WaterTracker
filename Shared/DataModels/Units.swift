//
//  Units.swift
//  WaterTracer
//
//  Created by Yu Liang on 10/30/24.
//

enum WaterUnits: Codable, Hashable {
    
    case oz
    case ml
    
    var cupDefaultCapacity: Double {
        switch self {
        case .oz:
            return 8.5
        case .ml:
            return 250.0
        }
    }
    
    var cupMinimumNum: Double {
        switch self {
        case .oz:
            return 0.1
        case .ml:
            return 10
        }
    }

    var unitStep: Double {
        switch self {
        case .oz:
            return 0.1
        case .ml:
            return 10
        }
    }
    
    var unitStr: String {
        switch self {
        case .oz:
            return "oz"
        case .ml:
            return "ml"
        }
    }
    
    var defaultDailyGoal: Double {
        switch self {
        case .oz:
            return 64.0
        case .ml:
            return 2500.0
        }
    }
}
