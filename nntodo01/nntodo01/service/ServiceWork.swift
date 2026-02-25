//
//  ServiceWork.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/12/26.
//

import Foundation
import CoreData


class ServiceWork: NnService {
    ///
    /// - 기본 정보
    /// id  :   고유번호
    /// title   :   이름
    /// createdDate   :   생성 날짜
    /// updateDate  :   수정 날짜
    /// isDone  :   완료 여부
    /// - 추가 내용
    /// memo    :   메모
    /// parent  :   상위 work
    /// children  :   하위 work
    /// - 분류 관련
    /// isMarked    :   즐겨찾기
    /// planType    :   일정 타입 [ 년, 월, 주, 일]
    /// planedDay  :    계획된 날짜
    /// planedWeek :   계획된 주
    /// planedMonth :   계획된 월
    /// planedYear  :   계획된 연도
    /// kategory    :   카테고리
    ///
    
    // MARK: create
    // 기본 생성
    func getNew(
        _ title: String,
        isDone: Bool = false,
    ) -> Work {
        let new = Work(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.title = title
        new.isDone = isDone
        return new
    }
    // 추가 내용 포함 생성
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, isDone: isDone)
        new.memo = memo
        new.parent = parent
        return new
    }
    // 분류 내용 포함 생성
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil
    ) -> Work {
        let new = getNew(title, isDone: isDone, memo: memo, parent: parent)
        new.isMarked = isMarked
        new.listTypePlan = listTypePlan
        new.kategory = kategory
        return new
    }
    // 일별 계획
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedDay: Int,
        planedMonth: Int,
        planedYear: Int
    ) -> Work? {
        if listTypePlan.contains(.day) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory)
            new.planedDay = Int64(planedDay)
            new.planedMonth = Int64(planedMonth)
            new.planedYear = Int64(planedYear)
            return new
        }
        return nil
    }
    // 주별 계획
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedWeek: Int,
        planedMonth: Int,
        planedYear: Int
    ) -> Work? {
        if listTypePlan.contains(.week) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory)
            new.planedWeek = Int64(planedWeek)
            new.planedMonth = Int64(planedMonth)
            new.planedYear = Int64(planedYear)
            return new
        }
        return nil
    }
    // 월별 계획
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedMonth: Int,
        planedYear: Int
    ) -> Work? {
        if listTypePlan.contains(.month) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory)
            new.planedMonth = Int64(planedMonth)
            new.planedYear = Int64(planedYear)
            return new
        }
        return nil
    }
    // 연별 계획
    func getNew(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedYear: Int
    ) -> Work? {
        if listTypePlan.contains(.year) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory)
            new.planedYear = Int64(planedYear)
            return new
        }
        return nil
    }
    // 생성 및 저장
    func create(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil
    ) -> Result {
        let new = getNew(title, isDone: isDone, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory)
        // save
        NnLogger.log("New Work was created. (work: \(new))", level: .info)
        return save()
    }
    // 일별 계획
    func create(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedDay: Int,
        planedMonth: Int,
        planedYear: Int
    ) -> Result {
        if listTypePlan.contains(.day) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory, planedDay: planedDay, planedMonth: planedMonth, planedYear: planedYear)
            NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
            return save()
        }
        return Result(code: "9999", msg: "listTypePlan does not contain .day")
    }
    // 주별 계획
    func create(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedWeek: Int,
        planedMonth: Int,
        planedYear: Int
    ) -> Result {
        if listTypePlan.contains(.week) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory, planedWeek: planedWeek, planedMonth: planedMonth, planedYear: planedYear)
            NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
            return save()
        }
        return Result(code: "9999", msg: "listTypePlan does not contain .week")
    }
    // 월별 계획
    func create(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedMonth: Int,
        planedYear: Int
    ) -> Result {
        if listTypePlan.contains(.month) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory, planedMonth: planedMonth, planedYear: planedYear)
            NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
            return save()
        }
        return Result(code: "9999", msg: "listTypePlan does not contain .month")
    }
    // 연별 계획
    func create(
        _ title: String,
        isDone: Bool = false,
        memo: String? = nil,
        parent: Work? = nil,
        isMarked: Bool = false,
        listTypePlan: TypePlan = [],
        kategory: Kategory? = nil,
        planedYear: Int
    ) -> Result {
        if listTypePlan.contains(.year) {
            let new = getNew(title, isDone: isDone, memo: memo, parent: parent, isMarked: isMarked, listTypePlan: listTypePlan, kategory: kategory, planedYear: planedYear)
            NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
            return save()
        }
        return Result(code: "9999", msg: "listTypePlan does not contain .year")
    }
    
    // MARK: read
    // constant
    private let sortDefalt: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Work.createdDate, ascending: true)]
    // common func
    private func fetch<Work>(_ request: NSFetchRequest<Work>) -> [Work] {
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
    }
    // 전체 리스트
    func fetchAll() -> [Work] {
        let req: NSFetchRequest<Work> = Work.fetchRequest()
        req.sortDescriptors = sortDefalt
        return fetch(req)
    }
    // 조건부 리스트
    func fetchList(_ predicate: NSPredicate, sort: [NSSortDescriptor]? = nil) -> [Work] {
        let req: NSFetchRequest<Work> = Work.fetchRequest()
        req.predicate = predicate
        req.sortDescriptors = sort ?? sortDefalt
        return fetch(req)
    }
    // 특정
    func fetchOne(_ id: UUID) -> Work? {
        let request: NSFetchRequest<Work> = Work.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return fetch(request).first
    }
    // 작업 수
    func getCntNotDone(templete: Templete) -> Int {
        if let predicate = templete.predicate {
            return fetchList(predicate).filter { !$0.isDone }.count
        } else {
            return fetchAll().filter { !$0.isDone }.count
        }
    }

    // MARK: update
    // 일괄
    func update(_ newWork: Work) -> Result {
        // auto
        newWork.updatedDate = Date()
        // save
        return save()
    }
    // 한 요소
    func update(_ work: Work, key: String, value: Any) -> Result {
        switch key {
        case "title":
            if let newValue = value as? String { work.title = newValue }
        case "isDone":
            if let newValue = value as? Bool { work.isDone = newValue }
        case "memo":
            if let newValue = value as? String { work.memo = newValue }
        case "isMarked":
            if let newValue = value as? Bool { work.isMarked = newValue }
        case "listTypePlan":
            if let newValue = value as? TypePlan { work.listTypePlan = newValue }
        case "planedDay":
            if let newValue = value as? Int64 { work.planedDay = newValue }
        case "planedWeek":
            if let newValue = value as? Int64 { work.planedWeek = newValue }
        case "planedMonth":
            if let newValue = value as? Int64 { work.planedMonth = newValue }
        case "planedYear":
            if let newValue = value as? Int64 { work.planedYear = newValue }
        case "kategory":
            if let newValue = value as? Kategory { work.kategory = newValue }
//        case "children":
//            if let newValue = value as? [Work] {
//                for i in newValue.indices {
//                    newValue[i].sortNum = "\(i)"
//                }
//            }
        default:
            NnLogger.log("\(key) was not existed.")
            return Result(code: "9999", msg: "업데이트 실패")
        }
        return update(work)
    }
    // 자식 추가
    func addChild(_ name: String, isDone: Bool = false, target: Work) -> Result  {
        target.addToChildren(getNew(name, isDone: isDone))
        NnLogger.log("New subwork added. (subwork's count: \(target.children?.count ?? 0))", level: .info)
        return save()
    }
    // 자식 리스트
    func getChildren(_ target: Work) -> [Work]{
        return fetchList(NSPredicate(format: "parent == %@", target))
    }
    
    // MARK: delete
    func delete(_ work: Work) -> Result {
        context.delete(work)
        return save()
    }
}
