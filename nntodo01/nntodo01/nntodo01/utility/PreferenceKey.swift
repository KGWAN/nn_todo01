//
//  PreferenceKey.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/3/26.
//

import Foundation
import SwiftUICore

struct KeyHeight: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
        print("vv: \(value)")
    }
}
