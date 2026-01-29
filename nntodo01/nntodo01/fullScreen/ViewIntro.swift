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
        VStack {
            Text("nn To Do 시작")
                .font(.title2)
                .padding(.horizontal, 5)
                .padding(.vertical, 10)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .padding(10)
            
            Button {
                NnLogger.log("BtnText was tapped.", level: .debug)
                onFinished()
            } label: {
                Text("시작하기")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth:.infinity)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(Color.black)
            }
        }
        .padding()
    }
}

#Preview {
    ViewIntro(
        onFinished: {
            NnLogger.log("Intro was finished.", level: .debug)
        }
    )
}
