//
//  DateHandling.swift
//  WaterTracer
//
//  Created by Yu Liang on 11/4/24.
//
import Foundation

func getStartOfDate(date: Date) -> Date {
    return Calendar(identifier: .gregorian).startOfDay(for: Date())
}
