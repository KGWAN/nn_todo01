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
struct Provider: AppIntentTimelineProvider {
    //
    // 위젯이 처음 설치될 때 보여줄 가짜 데이터.
    //
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), cnt: 0)
    }
    //
    // 위젯 갤러리에서 미리보기로 보여줄 데이터.
    //
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, cnt: 3)
    }
    //
    // 시스템에 스케줄표를 전달하는 역할.
    //
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
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
            try cnt = context.fetch(req).count
        } catch {
            fatalError("Fetching Failed: \(error)")
        }
        // Entry 생성
        let entry = SimpleEntry(date: currentDate, configuration: configuration, cnt: cnt)
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
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    
    let cnt: Int // 오늘 남은 할 일 개수
}

//
// 레이아웃
//
struct oliiTodoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("오늘")
            Text(entry.date, style: .date)
            Text("남은 할 일")
            Text("\(entry.cnt)개")
        }
    }
}

//
// 선언부
// ID, 표시 이름, 설명, 그리고 어떤 Provider와 View를 사용할지 연결해주는 지점
// 위젯의 크기도 여기서 결정
//
struct oliiTodoWidget: Widget {
    let kind: String = "oliiTodoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            oliiTodoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("오늘의 남은 할 일")
        .description("오늘 남은 할 일의 개수를 보여줍니다.")
        .supportedFamilies([.systemSmall])
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

#Preview(as: .systemSmall) {
    oliiTodoWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, cnt: 0)
    SimpleEntry(date: .now, configuration: .starEyes, cnt: 10)
}
