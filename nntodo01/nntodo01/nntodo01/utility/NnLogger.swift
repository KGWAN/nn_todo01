//
//  Logger.swift
//  nntodo01
//
//  Created by JUNGGWAN KIM on 1/5/26.
//

import Foundation
import os

struct NnLogger {

    private static let subsystem = Bundle.main.bundleIdentifier ?? "App"
    private static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    enum LogLevel: String {
        case debug = "🐛 DEBUG"
        case info  = "ℹ️ INFO"
        case warn  = "⚠️ WARN"
        case error = "❌ ERROR"
    }

    static func log(
        _ message: String,
        level: LogLevel = .debug,
        category: String = "General",
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = """
        \(level.rawValue),
        \(fileName),
        \(function),
        line: \(line): 
        \(message)
        """
        
        if isPreview {
            print("\(logMessage)")
            return
        }
        
        #if DEBUG
        let logger = Logger(subsystem: subsystem, category: category)
         
        switch level {
        case .debug:
            logger.debug("\(logMessage)")
        case .info:
            logger.info("\(logMessage)")
        case .warn:
            logger.warning("\(logMessage)")
        case .error:
            logger.error("\(logMessage)")
        }
        #endif
    }
}
