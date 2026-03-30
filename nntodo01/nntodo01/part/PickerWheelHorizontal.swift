//
//  PickerWheelHorizental.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 3/30/26.
//

import SwiftUI

struct PickerWheelHorizontal: View {
    // in
    private let range: Array<Int>
    private let startPoint: Int
    private let onChange: (Int) -> Void
    // init
    init(range: Array<Int>, startPoint start: Int, onChange: @escaping (Int) -> Void) {
        self.range = range
        self.startPoint = start
        self.onChange = onChange
    }
    // state
    @State private var target: Int? = nil
    // constant
    private let width: CGFloat = 280
    private let widthItem: CGFloat = 60
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(range, id: \.self) { i in
                    Text("\(String(i))")
                        .id(i)
                        .font(.system(size: target == i ? 20 : 16, weight: target == i ? .bold : .light))
                        .foregroundStyle(target == i ? .cyan : .gray)
                        .frame(width: widthItem)
                        .onTapGesture {
                            withAnimation {
                                target = i
                            }
                        }
                }
            }
            .scrollTargetLayout(isEnabled: true)
        }
        .scrollPosition(id: $target)
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, (width - widthItem) / 2)
        .frame(width: width)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { 
                withAnimation() {
                    target = startPoint
                }
            }
        }
        .onChange(of: target ?? -1) { oldValue, newValue in
            if target ?? -1 >= 0 {
                onChange(newValue)
            }
        }
    }
}

#Preview {
    @Previewable @State var selected: Int = 3
    let arr: Array<Int> = Array(1...12)
    
    PickerWheelHorizontal(range: arr, startPoint: selected) { target in
        print("target was changed. >>> \(target)")
    }
    .background(.red.opacity(0.2))

}
