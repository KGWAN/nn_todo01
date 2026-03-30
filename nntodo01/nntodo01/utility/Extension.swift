//
//  Extension.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/8/26.
//

import Foundation
import SwiftUI

// MARK: Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b, a: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b, a) = (
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17,
                255
            )
        case 6: // RGB (24-bit)
            (r, g, b, a) = (
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF,
                255
            )
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF,
                int >> 24
            )
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: Date
extension Date {
    func getStrDate(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: View
extension View {
    func nnToolbar(
        _ title: String,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(ModifierToolbar(title: title, onDismiss: onDismiss, contentTrailing: { EmptyView() }))
    }
    
    func nnToolbar<R: View>(
        _ title: String,
        onDismiss: @escaping () -> Void = {},
        contentTrailing: @escaping () -> R
    ) -> some View {
        self.modifier(ModifierToolbar(title: title, onDismiss: onDismiss, contentTrailing: contentTrailing))
    }
    
    func toast(_ msg: String, isPresented: Binding<Bool>) -> some View {
        self.modifier(ModifierToast(msg, isPresented: isPresented))
    }
}

// MARK: Calendar
extension Calendar {
    static var nn: Calendar {
        let cal = Calendar.current
        // 공통적인 설정
        return cal
    }
    
    // 주에 대한 정보
    struct Week: Identifiable {
        let id: UUID = UUID()
        let num: Int
        let startDate: Date
        let endDate: Date
    }
    
    // 월의 주들을 반환하는 함수
    func getWeeksInMonth(month: Int, year: Int) -> [Week] {
        // components 생성
        var componentsTarget = DateComponents()
        componentsTarget.year = year
        componentsTarget.month = month
        componentsTarget.day = 1
        // 해달 월의 처음 날짜
        guard let dateStart = self.date(from: componentsTarget) else {return []}
        // 일수
        guard let range = self.range(of: .day, in: .month, for: dateStart) else {return []}
        // 해당 월의 마지막 날짜
        guard let dateEnd = self.date(byAdding: .day, value: range.count - 1, to: dateStart) else {return []}
        // 첫째주
        // yearForWeekOfYear: 주를 단위로 할때 해당 주가 몇 년도인지를 반환
        // weekOfYear: 몇 번째 주인지를 반환
        // >>> dateWeekStart는 yearForWeekOfYear의 연도에 weekOfYear 번째 주의 첫번째 날짜
        let componentsWeekFirst = self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: dateStart)
        guard var dateWeekStart = self.date(from: componentsWeekFirst) else {return []}
        // 초기 값
        var listWeek: [Week] = []
        var cntWeek: Int = 1
        // 연산
        while dateWeekStart <= dateEnd {
            // week 생성 및 추가
            guard let dateWeekEnd = self.date(byAdding: .day, value: 6, to: dateWeekStart) else {break}
            listWeek.append(Week(num: cntWeek, startDate: dateWeekStart, endDate: dateWeekEnd))
            // 다음주로 이동
            guard let dateWeekStartNext = self.date(byAdding: .day, value: 7, to: dateWeekStart) else {break}
            dateWeekStart = dateWeekStartNext
            cntWeek += 1
        }
        // return
        return listWeek
    }
    
    func getFirstDateOfMonth(_ month: Int, year: Int) -> Date? {
        // components 생성
        var componentsTarget = DateComponents()
        componentsTarget.year = year
        componentsTarget.month = month
        componentsTarget.day = 1
        // 해달 월의 처음 날짜
        guard let startOfMonth = self.date(from: componentsTarget) else { return nil }
        return startOfMonth
    }
    
    func getDaysInMonth(firstDay base: Date) -> [Date] {
        // 이번 달이 총 며칠인지 확인 (28, 30, 31일 등)
        let range = self.range(of: .day, in: .month, for: base)!
        // 시작일부터 끝일까지 날짜 배열 생성
        return range.compactMap { day -> Date? in
            return self.date(byAdding: .day, value: day - 1, to: base)
        }
    }
    func getDaysInMonth(month: Int, year: Int) -> [Date] {
        guard let base = getFirstDateOfMonth(month, year: year) else { return [] }
        // 이번 달이 총 며칠인지 확인 (28, 30, 31일 등)
        let range = self.range(of: .day, in: .month, for: base)!
        // 시작일부터 끝일까지 날짜 배열 생성
        return range.compactMap { day -> Date? in
            return self.date(byAdding: .day, value: day - 1, to: base)
        }
    }
    
    func getDay(_ date: Date) -> Int {
        return self.component(.day, from: date)
    }
    
    func getMonth(_ date: Date) -> Int {
        return self.component(.month, from: date)
    }
    
    func getYear(_ date: Date) -> Int {
        return self.component(.year, from: date)
    }
    
    func getWeek(_ date: Date) -> Int {
        return self.component(.weekOfMonth, from: date)
    }
}

// MARK: EnvironmentValues
extension EnvironmentValues {
    struct PreviewStateKey: EnvironmentKey {
        static let defaultValue: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    var isPreview: Bool {
        get {
            self[PreviewStateKey.self]
        } set {
            self[PreviewStateKey.self] = newValue
        }
    }
}
