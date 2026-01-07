//
//  ViewMain.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

struct ViewMain: View {
    var body: some View {
        NavigationStack {
            VStack {
                ViewListTodo()
            }
        }
        .navigationTitle("Todo List")
    }
}

#Preview {
    ViewMain()
}
