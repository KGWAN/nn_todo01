//
//  ManagerPopup.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/26/26.
//

import Foundation

class ManagerPopup: ObservableObject {
    @Published var popup: NnPopup? = nil
    
    func show(_ popup: NnPopup) {
//        withAnimation {
            self.popup = popup
//        }
    }
    
    func hide() {
//        withAnimation {
            self.popup = nil
//        }
    }
}
