//
//  LogService.swift
//  SwiftLogger
//
//  Created by Shamvil on 16/08/17.
//  Copyright © 2017 qburst. All rights reserved.
//

import UIKit

class LogService: NSObject {
    
    public class func logError(logMessage: String, fileName: String = #file, functionName: String = #function) {
        setLogEvent(message: logMessage, logEvent: LogEvent.e.rawValue, fileName: fileName, functionName: functionName)
    }
    
    public class func logInfo(logMessage: String, fileName: String = #file, functionName: String = #function) {
        setLogEvent(message: logMessage, logEvent: LogEvent.i.rawValue, fileName: fileName, functionName: functionName)
    }
    
    public class func logDebug(logMessage: String, fileName: String = #file, functionName: String = #function) {
        setLogEvent(message: logMessage, logEvent: LogEvent.d.rawValue, fileName: fileName, functionName: functionName)
    }
    
    public class func logWarning(logMessage: String, fileName: String = #file, functionName: String = #function) {
        setLogEvent(message: logMessage, logEvent: LogEvent.w.rawValue, fileName: fileName, functionName: functionName)
    }
    
    public class func deleteLogOlderThan(days: Int) {
        Logger.deleteOlderLogs(days: days)
    }
    
    static func setLogEvent(message: String, logEvent: String, fileName: String, functionName: String) {
        let logEvent = logEvent
        Logger.saveLogsToFile(message: message, logEvent: logEvent, className: fileName, functionName: functionName)
    }
    
}
