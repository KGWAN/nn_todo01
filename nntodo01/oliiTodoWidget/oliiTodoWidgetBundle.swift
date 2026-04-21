//
//  oliiTodoWidgetBundle.swift
//  oliiTodoWidget
//
//  Created by JUNGGWAN KIM on 4/13/26.
//
//  하나의 앱에서 여러 개의 위젯을 제공하고 싶을 때 이들을 하나로 묶어주는 역할
//

import WidgetKit
import SwiftUI

@main
struct oliiTodoWidgetBundle: WidgetBundle {
    var body: some Widget {
        oliiTodoWidget()
//        oliiTodoWidgetControl()
//        oliiTodoWidgetLiveActivity()
    }
}
