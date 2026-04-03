//
//  ColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import Foundation
import SwiftUI
import UIKit

enum ColorMarkKategory: String, CaseIterable, Identifiable {
    case red = "#ff0000"
    case lightcoral = "#F08080"
    case orange = "#ffa500"
    case moccasin = "#FFE4B5"
    case yellow = "#ffff00"
    case greenyellow = "#ADFF2F"
    case green = "008000"
    case steelblue = "#4682B4"
    case blue = "#0000ff"
    case mediumblue = "#0000CD"
    case navy = "#000080"
    case mediumorchid = "#BA55D3"
    case purple = "#800080"
    case pink = "#FFC0CB"
    
    var id: Self { self }
    
    var color: Color { return Color(hex: self.rawValue) }
}

enum PhotoMarkKategory: String, CaseIterable, Identifiable {
    case p01 = "bgKate00"
    case p02 = "bgKate01"
    case p03 = "bgKate02"
    
    var id: Self { self }
    var img: UIImage { return UIImage(named: self.rawValue) ?? UIImage.bgKate00 }
}
