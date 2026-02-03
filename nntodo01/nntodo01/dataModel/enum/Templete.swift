//
//  Templete.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/27/26.
//

import Foundation

enum Templete: String, CaseIterable, Identifiable {
    case today = "오늘 할 일"
    case marked = "별표"
//    case plan = "계획된 일정"
    case nomal = "모두 보기"
    
    var id: Self { self }
    
    var predicate: NSPredicate? {
        switch self {
        case .nomal:
            return nil
        case .today:
            return NSPredicate(format: "isToday == %@", NSNumber(value: true))
        case .marked:
            return NSPredicate(format: "isMarked == %@", NSNumber(value: true))
//        case .plan:
//            return NSPredicate(format: "isMarked == %@", NSNumber(value: true))
        }
    }
    
    var nameIcon: String {
        switch self {
        case .nomal: return ""
        case .today: return ""
        case .marked: return ""
//        case .plan: return ""
        }
    }
}
