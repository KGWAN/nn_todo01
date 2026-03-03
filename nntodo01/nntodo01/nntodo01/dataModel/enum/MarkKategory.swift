//
//  ColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import Foundation
import SwiftUICore
import UIKit

enum ColorMarkKategory: String, CaseIterable, Identifiable {
    case red = "#ff0000"
    case orange = "#ffa500"
//    case yellow = "#ffff00"
    case green = "008000"
    case blue = "#0000ff"
    
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
