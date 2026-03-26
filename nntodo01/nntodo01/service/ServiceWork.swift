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
    func getNew(_ title: String, parent: Work? = nil) -> Work {
        let new = Work(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.title = title
        // parent
        if let p = parent {
            new.parent = p
            new.depth = p.depth + 1
            new.isLocked = p.isDone
            new.kategory = p.kategory
        }
        return new
    }
    // preview에서 확인을 위해 생성
    func getDoneWork(_ title: String) -> Work {
        let new = Work(context: context)
        // auto
        new.id = UUID()
        new.createdDate = Date()
        // user's input
        new.title = title
        new.isDone = true
        return new
    }
    // 별표 생성
    func getNew(
        _ title: String,
        isMarked: Bool = false,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.isMarked = isMarked
        return new
    }
    // kategory에서 생성
    func getNew(
        _ title: String,
        kategory: Kategory? = nil,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.kategory = kategory
        return new
    }
    // 연도 달력에서 생성
    func getNew(
        _ title: String,
        planedYear: Int,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.planType = TypePlan.year.rawValue
        new.planedYear = Int64(planedYear)
        return new
    }
    // 월 달력에서 생성
    func getNew(
        _ title: String,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.planType = TypePlan.month.rawValue
        new.planedMonth = Int64(planedMonth)
        new.planedYear = Int64(planedYear)
        return new
        
    }
    // 주 달력에서 생성
    func getNew(
        _ title: String,
        planedWeek: Int,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.planType = TypePlan.week.rawValue
        new.planedWeek = Int64(planedWeek)
        new.planedMonth = Int64(planedMonth)
        new.planedYear = Int64(planedYear)
        return new
    }
    // 날짜 달력에서 생성
    func getNew(
        _ title: String,
        planedDay: Int,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil
    ) -> Work {
        let new = getNew(title, parent: parent)
        new.planType = TypePlan.day.rawValue
        new.planedDay = Int64(planedDay)
        new.planedMonth = Int64(planedMonth)
        new.planedYear = Int64(planedYear)
        return new
    }
    // 생성
    // 기본 생성
    func create(
        _ title: String,
        parent: Work? = nil,
    ) -> Result {
        let new = getNew(title, parent: parent)
        // save
        NnLogger.log("New Work was created. (work: \(new))", level: .info)
        return save()
    }
    // 별표 생성
    func create(
        _ title: String,
        isMarked: Bool = false,
        parent: Work? = nil,
    ) -> Result {
        let new = getNew(title, isMarked: isMarked, parent: parent)
        // save
        NnLogger.log("New Work was created. (work: \(new))", level: .info)
        return save()
    }
    // kategory에서 생성
    func create(
        _ title: String,
        kategory: Kategory? = nil,
        parent: Work? = nil
    ) -> Result {
        let new = getNew(title, kategory: kategory, parent: parent)
        NnLogger.log("New Work was created. (work: \(new))", level: .info)
        return save()
    }
    // 연도 달력에서 생성
    func create(
        _ title: String,
        planedYear: Int,
        parent: Work? = nil,
    ) -> Result {
        let new = getNew(title, planedYear: planedYear, parent: parent)
        NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
        return save()
    }
    // 월 달력에서 생성
    func create(
        _ title: String,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil
    ) -> Result {
        let new = getNew(title, planedMonth: planedMonth, planedYear: planedYear ,parent: parent)
        NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
        return save()
    }
    // 주 달력에서 생성
    func create(
        _ title: String,
        planedWeek: Int,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil
    ) -> Result {
        let new = getNew(title, planedWeek: planedWeek, planedMonth: planedMonth, planedYear: planedYear, parent: parent)
        NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
        return save()
    }
    // 날짜 달력에서 생성
    func create(
        _ title: String,
        planedDay: Int,
        planedMonth: Int,
        planedYear: Int,
        parent: Work? = nil,
    ) -> Result {
        let new = getNew(title, planedDay: planedDay, planedMonth: planedMonth, planedYear: planedYear, parent: parent)
        NnLogger.log("New Work was created. (work: \(String(describing: new)))", level: .info)
        return save()
    }
    
    // MARK: read
    // constant
    private let sortDefalt: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Work.createdDate, ascending: false)]
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
    func update(_ work: Work, key: String, value: Any?) -> Result {
        switch key {
        case "title":
            if let newValue = value as? String { work.title = newValue }
        case "isDone":
            if let newValue = value as? Bool {
                work.isDone = newValue
                getChildren(work).forEach {
                    $0.isLocked = work.isDone
                }
            }
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
            if value != nil {
                if let newValue = value as? Kategory { work.kategory = newValue }
            } else {
                work.kategory = nil
            }
        case "isLocked":
            if let newValue = value as? Bool { work.isLocked = newValue }
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
    // 자식 리스트
    func getChildren(_ target: Work) -> [Work]{
        return fetchList(NSPredicate(format: "parent == %@", target))
    }
    
    // MARK: delete
    // 자식과 함께 삭제
    func deleteWithChildren(_ work: Work) -> Result {
        getChildren(work).forEach {
            if !deleteWithChildren($0).isSuccess {
                NnLogger.log("It's failed to delete work: \($0)", level: .error)
            }
        }
        context.delete(work)
        return save()
    }
    // 자신만 삭제, 자식은 재위치시킴
    func delete(_ work: Work) -> Result {
        raiseChildren(of: work)
        context.delete(work)
        return save()
    }
    // target의 자손들의 위치를 재위치시키는 함수
    private func raiseChildren(of target: Work) {
        getChildren(target).forEach {
            raiseChildren(of: $0)
            $0.depth -= 1
            if let p = target.parent {
                $0.parent = p
                $0.isLocked = p.isDone
            }
        }
    }
}
