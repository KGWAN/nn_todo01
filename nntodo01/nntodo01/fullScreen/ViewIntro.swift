//
//  fullScreen.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import SwiftUI

struct ViewIntro: View {
    let onFinished: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            btnStart
            VStack(spacing: 0) {
                Spacer()
                Text("중앙의 버튼을 누르고 시작하세요.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.gray)
                    .frame(maxWidth:.infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            }
        }
    }
    
    
    // ViewBuilder
    @ViewBuilder
    private var btnStart: some View {
        Button {
            NnLogger.log("todo was started.", level: .info)
            onFinished()
        } label: {
            VStack(spacing: 0) {
                Text("olii")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.yellow)
                    .frame(maxWidth:.infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                Text("TODO")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.yellow)
                    .frame(maxWidth:.infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            }
            .frame(width: 150, height: 150)
            .background {
                Color.white
                    .cornerRadius(75)
                    .overlay {
                        RoundedRectangle(cornerRadius: 75)
                            .stroke(.yellow.opacity(0.2), lineWidth: 10)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 2.5, x: 0, y: 0)
            }
            .padding(2.5)
        }
    }
}

#Preview {
    ViewIntro(
        onFinished: {
            NnLogger.log("Intro was finished.", level: .debug)
        }
    )
}
