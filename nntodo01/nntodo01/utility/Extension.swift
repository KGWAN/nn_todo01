//
//  Extension.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import Foundation
import SwiftUICore

// MARK: View
extension View {
    func nnToolbar(
        _ title: String,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(NnToolbarModifier(title: title, onDismiss: onDismiss, contentTrailing: { EmptyView() }))
    }
    
    func nnToolbar<R: View>(
        _ title: String,
        onDismiss: @escaping () -> Void = {},
        contentTrailing: @escaping () -> R
    ) -> some View {
        self.modifier(NnToolbarModifier(title: title, onDismiss: onDismiss, contentTrailing: contentTrailing))
    }
}
