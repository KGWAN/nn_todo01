//
//  ViewSeletColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI

struct ViewSelectPhotoMarkKategory: View {
    @Binding var selectedOne : PhotoMarkKategory
    
    // constant
    private let radius : CGFloat = 20
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(PhotoMarkKategory.allCases, id: \.id) { type in
                    ZStack {
                        Button {
                            selectedOne = type
                        } label: {
                            if let img = UIImage(named: type.rawValue) {
                                Image(uiImage: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: radius*2, height: radius*2, alignment: .center)
                                    .cornerRadius(radius)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: radius*2, height: radius*2, alignment: .center)
                            }
                        }
                        if selectedOne == type {
                            Circle()
                                .fill(Color.white)
                                .frame(width: radius*0.7, alignment: .center)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    @Previewable @State var selectedOne : PhotoMarkKategory = PhotoMarkKategory.allCases[0]
    
    Group {
        ViewSelectPhotoMarkKategory(selectedOne: $selectedOne)
    }
    .frame(maxWidth: .infinity, maxHeight: 40)
    .background(Color.yellow)
}
