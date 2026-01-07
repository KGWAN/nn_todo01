//
//  SwiftUIView.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/6/26.
//

import SwiftUI

struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool = false
    
    init(_ title: String, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
    }
}

