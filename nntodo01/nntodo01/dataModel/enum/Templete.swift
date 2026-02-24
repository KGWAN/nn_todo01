//
//  Templete.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/27/26.
//

import Foundation
import SwiftUICore

enum Templete: String, CaseIterable, Identifiable {
//    case today = "오늘 할 일"
    case marked = "별표"
    case nomal = "모두 보기"
    
    var id: Self { self }
    
    var predicate: NSPredicate? {
        switch self {
        case .nomal:
            return nil
//        case .today:
//            return NSPredicate(format: "isToday == %@", NSNumber(value: true))
        case .marked:
            return NSPredicate(format: "isMarked == %@", NSNumber(value: true))
        }
    }
    
    var nameIcon: String {
        switch self {
        case .nomal: return "iconTempAll"
//        case .today: return "iconTempToday"
        case .marked: return "iconTempStar"
        }
    }
    
    var hexColor: String {
        switch self {
        case .nomal: return "#696969"
//        case .today: return "#1E90FF"
        case .marked: return "#FF8C00"
        }
    }
    
    var color: Color {
        Color(hex: self.hexColor) 
    }
}
