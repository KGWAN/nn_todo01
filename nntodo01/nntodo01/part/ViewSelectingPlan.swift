//
//  ItemYear.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/9/26.
//

import SwiftUI

struct ViewSelectingPlan: View {
    @Binding var listTypePlan: TypePlan
    
    var body: some View {
        HStack {
            ForEach(TypePlan.allCases, id: \.rawValue) { type in
                Button {
                    if listTypePlan.contains(type) {
                        listTypePlan.remove(type)
                    } else {
                        listTypePlan.insert(type)
                    }
                    NnLogger.log("Plan's Type was changed. >>> \(listTypePlan.rawValue)")
                } label: {
                    Text(type.name)
                        .foregroundStyle(listTypePlan.contains(type) ? .black : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(listTypePlan.contains(type) ? .white : .clear)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var listTypePlan: TypePlan = [.year]
    
    ViewSelectingPlan(listTypePlan: $listTypePlan)
}
