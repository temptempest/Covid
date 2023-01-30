//
//  Log+Extension.swift
//  Covid
//
//  Created by temptempest on 20.12.2022.
//

import Foundation

enum Log {
    enum LogLevel {
        case info, warning, error
        fileprivate var prefix: String {
            switch self {
            case .info: return "INFO"
            case .warning: return "WARN ⚠️"
            case .error: return "ALERT ❌"
            }
        }
    }
    
    struct Context {
        let file: String
        let function: String
        let line: Int
        var description: String {
            return "\((file as NSString).lastPathComponent):\(line) \(function)"
        }
    }
}

extension Log {
    static func info(_ str: String, shouldLogContext: Bool = true, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        Log.handleLog(level: .info, str: str.description, error: nil, shouldLogContext: shouldLogContext, context: context)
    }
    static func warning(_ str: String, _ error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        if let error = error {
            Log.handleLog(level: .warning, str: str.description, error: error, shouldLogContext: true, context: context)
        } else {
            Log.handleLog(level: .warning, str: str.description, error: nil, shouldLogContext: true, context: context)
        }
    }
    
    static func error(_ str: String, _ error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)
        if let error = error {
            Log.handleLog(level: .error, str: str.description, error: error, shouldLogContext: true, context: context)
        } else {
            Log.handleLog(level: .error, str: str.description, error: nil, shouldLogContext: true, context: context)
        }
    }
    
    fileprivate static func handleLog(level: LogLevel, str: String,
                                      error: Error?, shouldLogContext: Bool,
                                      context: Context) {
        let logComponents = ["[\(level.prefix)]", str]
        var fullString = logComponents.joined(separator: " ")
        if shouldLogContext {
            fullString += " ➜ \(context.description)"
        }
#if DEBUG
        print(fullString)
#endif
    }
}
