//
//  Plan.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/20/26.
//

import Foundation

struct TypePlan: OptionSet, Codable, Hashable {
    let rawValue: Int64
    
    static let year = TypePlan(rawValue: 1 << 0) // 0001
    static let month = TypePlan(rawValue: 1 << 1) // 0010
    static let week = TypePlan(rawValue: 1 << 2) // 0100
    static let day = TypePlan(rawValue: 1 << 3) // 1000
    
    static let allCases: [TypePlan] = [.year, .month, .week, .day]
    
    var name: String {
        switch self {
        case .year: return "Yearly"
        case .month: return "Monthly"
        case .week: return "Weekly"
        case .day: return "Daily"
        default: return "Unknown"
        }
    }
}
