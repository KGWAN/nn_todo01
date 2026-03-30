//
//  ManagerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/26/26.
//

import Foundation
import SwiftUI

class ManagerPopup: ObservableObject {
    @Published var popup: NnPopup? = nil
    
    func show(_ popup: NnPopup) {
        withAnimation {
            self.popup = popup
        }
    }
    
    func hide() {
        withAnimation {
            self.popup = nil
        }
    }
    
    func replace(with newPopup: NnPopup) {
        hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 다음 사이클에 할당
            self.show(newPopup)
        }
    }
}
