//
//  ViewSeletColorMarkKategory.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/29/26.
//

import SwiftUI
import PhotosUI

struct ViewSelectUserMarkKategory: View {
    @Binding var selectedOne : UserPhoto?
    
    init(for selectedOne: Binding<UserPhoto?>) {
        self._selectedOne = selectedOne
        
        self._list = State(initialValue: service.fetchAll())
    }
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var list: [UserPhoto] = []
    @State private var idRefresh: UUID = UUID()
    // constant
    private let radius : CGFloat = 20
    private let service = ServiceUserPhoto()
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                // 추가 버튼
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ImgSafe("")
                        .frame(width: radius*2, height: radius*2, alignment: .center)
                        .cornerRadius(radius)
                }
                
//                if let selectedImg {
//                    selectedImg
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: radius*2, height: radius*2, alignment: .center)
//                        .cornerRadius(radius)
//                }
                
                if !list.isEmpty {
                    ForEach(list, id: \.id) { userPhoto in
                        ZStack {
                            Button {
                                selectedOne = userPhoto
                                if let path = userPhoto.path,
                                   let url = URL(string: path) {
                                    print("userPhoto.path : \(path)")
                                    print("userPhoto.url : \(url)")
                                    print("userPhoto.url.path : \(url.path())")
                                    print("img : \(UIImage(contentsOfFile: url.path()))")
                                    print("file exists:", FileManager.default.fileExists(atPath: url.path()))
                                }
                            } label: {
                                if let path = userPhoto.path,
                                    let url = URL(string: path),
                                   let img = UIImage(contentsOfFile: url.path()) {
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
                            if selectedOne == userPhoto {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: radius*0.7, alignment: .center)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .onChange(of: selectedItem) { oldValue, newValue in
                if let value = newValue {
                    loadImg(value)
                }
            }
        }
        .id(idRefresh)
    }
    
    
    // MARK: func
    private func reload() {
        list = service.fetchAll()
        idRefresh = UUID()
    }
    
    private func getUrl() -> URL {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(UUID().uuidString + ".jpg")
    }
    
    private func createUserPhoto(path: URL) -> Result {
        return service.insert(path.absoluteString)
    }
    
    private func saveImgFile(_ img: UIImage, location: URL) -> Result {
        if let data = img.jpegData(compressionQuality: 0.8) {
            try? data.write(to: location)
            return Result(code: "0000", msg: "이미지 저장 성공")
        }
        NnLogger.log("Failed to save img file", level: .error)
        return Result(code: "9999", msg: "이미지 저장 실패")
    }
    
    private func loadImg(_ item: PhotosPickerItem) {
        Task {
            let url = getUrl()
            if let data = try? await item.loadTransferable(type: Data.self),
               let img = UIImage(data: data),
               saveImgFile(img, location: url).isSuccess,
               createUserPhoto(path: url).isSuccess {
                reload()
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedOne : UserPhoto? = nil
    
    Group {
        ViewSelectUserMarkKategory(for: $selectedOne)
    }
    .frame(maxWidth: .infinity, maxHeight: 40)
    .background(Color.yellow)
}
