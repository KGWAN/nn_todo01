//
//  ViewProfile.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 2/6/26.
//

import SwiftUI

struct ViewProfile: View {
    @State var name: String = ""
    @State var numPhone: String = ""
    @State var email: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // profile
                ImgSafe("profile", color: .gray)
                    .frame(width: 50, height: 50)
                    .padding(.horizontal, 5)
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("NAME")
                        TextFieldTitle(placeholder: "사용자 명을 입력하세요.", text: $name)
                    }
                    Divider()
                        .padding(.horizontal, 5)
                    HStack {
                        Text("PHONE NUMBER")
                        TextFieldTitle(placeholder: "번호를 입력하세요.", text: $numPhone)
                    }
                    Divider()
                        .padding(.horizontal, 5)
                    HStack {
                        Text("E-MAIL")
                        TextFieldTitle(placeholder: "이메일을 입력하세요.", text: $email)
                    }
                    Divider()
                        .padding(.horizontal, 5)
                }
                .padding(5)
                Spacer()
                // 설정 버튼
                HStack {
                    ImgSafe("btnSetting", color: .blue)
                        .frame(width: 20, height: 20)
                    Text("설정")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.blue)
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
                .background(.gray.opacity(0.3))
                .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden()
            .nnToolbar("")
        }
    }
}

#Preview {
    
    ViewProfile(name: "", numPhone: "")
}
