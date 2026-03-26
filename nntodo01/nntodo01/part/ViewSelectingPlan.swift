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
        HStack(spacing: 5) {
            ForEach(TypePlan.allCases, id: \.rawValue) { type in
                Button {
                    withAnimation {
                        if listTypePlan.contains(type) {
                            listTypePlan.remove(type)
                        } else {
                            listTypePlan.insert(type)
                        }
                    }
                    NnLogger.log("Plan's Type was changed. >>> \(listTypePlan.rawValue)")
                } label: {
                    Text(type.name)
                        .fontWeight(listTypePlan.contains(type) ? .bold : .regular)
                        .foregroundStyle(listTypePlan.contains(type) ? .cyan : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(height: 30)
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
        .padding(2.5)
    }
}

#Preview {
    @Previewable @State var listTypePlan: TypePlan = [.year]
    
    ViewSelectingPlan(listTypePlan: $listTypePlan)
}
