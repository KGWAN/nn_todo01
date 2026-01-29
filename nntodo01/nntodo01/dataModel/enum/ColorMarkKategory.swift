//
//  ColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import Foundation
import SwiftUICore

enum ColorMarkKategory: String, CaseIterable, Identifiable {
    case red = "#ff0000"
    case orange = "#ffa500"
//    case yellow = "#ffff00"
    case green = "008000"
    case blue = "#0000ff"
    
    var id: Self { self }
    
    var color: Color { return Color(hex: self.rawValue) }
}
