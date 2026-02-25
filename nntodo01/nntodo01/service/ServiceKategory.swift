//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceKategory: NnService {
    ///
    /// - 기본 정보
    /// id  :   고유번호
    /// title   :   이름
    /// createdDate   :   생성 날짜
    /// updateDate  :   수정 날짜
    /// - 추가 내용
    /// memo    :   설명
    /// works  :   등록된 작업들
    /// - 설정 관련
    /// markType  :   테마 타입 [색, 사진, 사용자지정] (default: 색)
    /// color    :  테마 색
    /// photo   :   사진
    /// userPhoto   :   사용자 지정 사진
    ///
    
    // MARK: create
    // 기본 생성
    func getNew(
        // 기본 정보
        _ title: String,
        description: String? = nil,
        markType: String = "color",
        color: String = ColorMarkKategory.allCases[0].rawValue,
        photo: String = PhotoMarkKategory.allCases[0].rawValue,
        userPhoto: UserPhoto? = nil
    ) -> Kategory {
        let kate = Kategory(context: context)
        // auto
        kate.id = UUID()
        kate.createdDate = Date()
        // user's input
        kate.title = title
        kate.memo = description
        kate.markType = markType
        kate.color = color
        kate.photo = photo
        kate.userPhoto = userPhoto
        // log
        return kate
    }
    // 생성 및 저장
    func create(
        _ title: String,
        description: String? = nil,
        markType: String = "color",
        color: String = ColorMarkKategory.allCases[0].rawValue,
        photo: String = PhotoMarkKategory.allCases[0].rawValue,
        userPhoto: UserPhoto? = nil
    ) -> Result {
        let new = getNew(title, description: description, markType: markType, color: color, photo: photo, userPhoto: userPhoto)
        // log
        NnLogger.log("on insert kategory. : \(new)", level: .info)
        // save
        return save()
    }
    // MARK: read
    // constant
    private let sortDefalt: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Work.createdDate, ascending: true)]
    // common func
    private func fetch<Kategory>(_ request: NSFetchRequest<Kategory>) -> [Kategory] {
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    // 모든 리스트
    func fetchAll() -> [Kategory] {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Kategory.createdDate, ascending: true)]
        return fetch(request)
    }
    // 카테고리 리스트
    func fetchList(_ predicate: NSPredicate, sort: [NSSortDescriptor]? = nil) -> [Kategory] {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sort ?? sortDefalt
        return fetch(request)
    }
    // 하나의 카테고리
    func fetchOne(_ id: UUID) -> Kategory? {
        let request: NSFetchRequest<Kategory> = Kategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return fetch(request).first
    }
    // 미완료 작업 수 가져오기
    func getCntNotDoneWorks(_ kategory: Kategory) -> Int {
//        return (kategory.works ?? []).filter { (element) -> Bool in
//            guard let value = element as? Work else { return false }
//            return !value.isDone
//        }.count
        kategory.works?.filtered(using: NSPredicate(format: "isDone == %@", NSNumber(value: false))).count ?? 0
    }
    
    func update(_ new: Kategory) -> Result {
        // auto
        new.updatedDate = Date()
        // log
        NnLogger.log("on updated kategory. : \(new)", level: .info)
        // save
        return save()
    }
    
    func delete(_ target: Kategory) -> Result {
        context.delete(target)
        return save()
    }
}
