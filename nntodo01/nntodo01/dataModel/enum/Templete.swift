//
//  Templete.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/27/26.
//

import Foundation
import SwiftUI

enum Templete: String, CaseIterable, Identifiable {
    case marked = "별표"
    case normal = "모두 보기"
    
    var id: Self { self }
    
    var predicate: NSPredicate? {
        switch self {
        case .normal:
            return nil
        case .marked:
            return NSPredicate(format: "isMarked == %@", NSNumber(value: true))
        }
    }
    
    var nameIcon: String {
        switch self {
        case .normal: return "iconTempAll"
        case .marked: return "iconTempStar"
        }
    }
    
    var hexColor: String {
        switch self {
        case .normal: return "#696969"
        case .marked: return "#FF8C00"
        }
    }
    
    var color: Color {
        Color(hex: self.hexColor) 
    }
    
    var cntNotDoneWorks: Int {
        ServiceWork().getCntNotDone(templete: self)
    }
    
    var predicateComplementary: NSPredicate? {
        switch self {
        case .marked:
            return NSPredicate(format: "isMarked == %@", NSNumber(value: false))
        default :
            return nil
        }
    }
}
