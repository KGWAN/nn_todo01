//
//  TypeMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

enum TypeMarkKategory: String, CaseIterable, Identifiable {
    case color = "color"
    case photo = "photo"
    case user = "user"
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .color:
            return "색"
        case .photo:
            return "사진"
        case .user:
            return "사용자 지정"
        }
    }
}
