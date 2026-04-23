//
//  oliiTodoWidget.swift
//  oliiTodoWidget
//
//  Created by JUNGGWAN KIM on 4/13/26.
//

import WidgetKit
import SwiftUI
import CoreData

//
// 위젯의 '타임라인(스케줄)'을 짜는 핵심 로직
//
struct ProviderForSmall: AppIntentTimelineProvider {
    //
    // 위젯이 처음 설치될 때 보여줄 가짜 데이터.
    //
    func placeholder(in context: Context) -> SimpleEntryForSmall {
        SimpleEntryForSmall(date: Date(), configuration: ConfigurationAppIntent(), cnt: 0)
    }
    //
    // 위젯 갤러리에서 미리보기로 보여줄 데이터.
    //
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntryForSmall {
        SimpleEntryForSmall(date: Date(), configuration: configuration, cnt: 3)
    }
    //
    // 시스템에 스케줄표를 전달하는 역할.
    //
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntryForSmall> {
        let currentDate = Date()
        let calendar: Calendar = .current
        // 데이터 읽기
        var cnt: Int = 0
        let context = PersistenceController.shared.container.viewContext
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let predicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d AND planedDay == %d", TypePlan.day.rawValue, year, month, day)
        let req: NSFetchRequest<Work> = Work.fetchRequest()
        req.predicate = predicate
        do {
            try cnt = context.fetch(req).filter({$0.isDone == false }).count
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
        // Entry 생성
        let entry = SimpleEntryForSmall(date: currentDate, configuration: configuration, cnt: cnt)
        // 타임라인 정책 결정
        let nextUdate = calendar.date(byAdding: .minute, value: 15, to: currentDate)!

        return Timeline(entries: [entry], policy: .after(nextUdate))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}
struct ProviderForMedium: AppIntentTimelineProvider {
    //
    // 위젯이 처음 설치될 때 보여줄 가짜 데이터.
    //
    func placeholder(in context: Context) -> SimpleEntryForMedium {
        SimpleEntryForMedium(date: Date(), configuration: ConfigurationAppIntent(), listWork: [])
    }
    //
    // 위젯 갤러리에서 미리보기로 보여줄 데이터.
    //
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntryForMedium {
        SimpleEntryForMedium(date: Date(), configuration: configuration, listWork: [])
    }
    //
    // 시스템에 스케줄표를 전달하는 역할.
    //
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntryForMedium> {
        let currentDate = Date()
        let calendar: Calendar = .current
        // 데이터 읽기
        var list: [Work] = []
        let context = PersistenceController.shared.container.viewContext
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        let predicate = NSPredicate(format: "(planType & %d) != 0 AND planedYear == %d AND planedMonth == %d AND planedDay == %d", TypePlan.day.rawValue, year, month, day)
        let req: NSFetchRequest<Work> = Work.fetchRequest()
        req.predicate = predicate
        let sortDescriptors: [NSSortDescriptor] = [
            NSSortDescriptor(keyPath: \Work.kategory?.title, ascending: true),
            NSSortDescriptor(keyPath: \Work.updatedDate, ascending: false),
            NSSortDescriptor(keyPath: \Work.createdDate, ascending: false)
        ]
        req.sortDescriptors = sortDescriptors
        do {
            try list = context.fetch(req)
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
        // Entry 생성
        let entry = SimpleEntryForMedium(date: currentDate, configuration: configuration, listWork: list)
        // 타임라인 정책 결정
        let nextUdate = calendar.date(byAdding: .minute, value: 15, to: currentDate)!

        return Timeline(entries: [entry], policy: .after(nextUdate))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

//
// 위젯에 표시할 데이터
// 화면에 그려질 때 필요한 모든 정보
// 반드시 date를 포함해야함: 시스템이 이 데이터를 언제 화면에 보여줄지를 결정하는 date
//
struct SimpleEntryForSmall: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let cnt: Int // 오늘 남은 할 일 개수
}
struct SimpleEntryForMedium: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let listWork: [Work] // 오늘 할 일 리스트
}

//
// 레이아웃
//
struct oliiTodoWidgetEntryViewForSmall : View {
    var entry: ProviderForSmall.Entry

    var body: some View {
        VStack(spacing: 10) {
            VStack {
                Text(getStrDate(entry.date, format: "M월, YYYY"))
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                Text(getStrDate(entry.date, format: "dd"))
                    .font(.system(size: 34))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
            }
            VStack() {
                Text("오늘 남은 할 일")
                    .font(.system(size: 16))
                    .foregroundColor(entry.cnt > 0 ? .black : .gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 10)
                if entry.cnt > 0 {
                    Text("\(entry.cnt)개")
                } else {
                    Text("없음")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity ,alignment: .leading)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
    
    private func getStrDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
struct oliiTodoWidgetEntryViewForMedium : View {
    var entry: ProviderForMedium.Entry

    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Text(getStrDate(entry.date, format: "M월, YYYY"))
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
                Text(getStrDate(entry.date, format: "dd"))
                    .font(.system(size: 34))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
                Spacer()
            }
            .frame(width: 100)
            VStack(spacing: 5) {
                Text("오늘 할 일")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 5)
                VStack(spacing: 3) {
                    if entry.listWork.isEmpty {
                        Text("없음")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 5)
                    } else {
                        ForEach(entry.listWork) { work in
                            if work.isDone {
                                HStack(spacing: 0) {
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 5, height: 5)
                                    Text(work.title ?? "이름 없음")
                                        .font(.system(size: 16))
                                        .strikethrough(true, color: .gray)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.horizontal, 5)
                                }
                            } else {
                                HStack(spacing: 0) {
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 5, height: 5)
                                    Text(work.title ?? "이름 없음")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity ,alignment: .leading)
                                        .padding(.horizontal, 5)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func getStrDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

//
// 선언부
// ID, 표시 이름, 설명, 그리고 어떤 Provider와 View를 사용할지 연결해주는 지점
// 위젯의 크기도 여기서 결정
//
struct oliiTodoWidgetForSmall: Widget {
    let kind: String = "oliiTodoWidgetForSmall"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ProviderForSmall()) { entry in
            oliiTodoWidgetEntryViewForSmall(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("오늘의 남은 할 일")
        .description("오늘 남은 할 일의 개수를 보여줍니다.")
        .supportedFamilies([.systemSmall])
    }
}
struct oliiTodoWidgetForMedium: Widget {
    let kind: String = "oliiTodoWidgetForMedium"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: ProviderForMedium()) { entry in
            oliiTodoWidgetEntryViewForMedium(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("오늘의 할 일")
        .description("오늘 할 일의 목록를 보여줍니다.")
        .supportedFamilies([.systemMedium])
    }
}

//
// 롱프레스로 위젯 편집을 할 때 정하는 옵션
//
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .systemSmall) {
//    oliiTodoWidgetForSmall()
//} timeline: {
//    SimpleEntryForSmall(date: .now, configuration: .smiley, cnt: 0)
//    SimpleEntryForSmall(date: .now, configuration: .starEyes, cnt: 10)
//}
#Preview(as: .systemMedium) {
    oliiTodoWidgetForMedium()
} timeline: {
    SimpleEntryForMedium(date: .now, configuration: .smiley, listWork: [])
    SimpleEntryForMedium(date: .now, configuration: .starEyes, listWork: [])
}
