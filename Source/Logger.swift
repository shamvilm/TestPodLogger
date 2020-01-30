//
//  Logger.swift
//  SwiftLogger
//
//  Created by Shamvil on 16/08/17.
//  Copyright © 2017 qburst. All rights reserved.
//

import UIKit

class Logger {
    
    static var logFilePath = String()
    static var logFolderPath = String()
    static let logsFolder = "Logs"
    static let fileManager = FileManager.default
    static var fileHandle: FileHandle?
    
    static var dateFormat = "dd-MM-yyyy hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    public class func saveLogsToFile(message: String, logEvent: String, className: String, functionName: String) {
        
        self.createBaseDirectory()
        let fileName = self.getFileName()
        
        if fileName != nil {
            let fileWritePath = NSURL(fileURLWithPath: logFolderPath).appendingPathComponent(fileName!)
            let filePath = String(describing: fileWritePath!)
            logFilePath = filePath.replacingOccurrences(of: "file://", with: "")
        }
        
        if !fileManager.fileExists(atPath: logFilePath) {
            fileManager.createFile(atPath: logFilePath, contents: nil, attributes: nil)
            fileHandle = FileHandle(forWritingAtPath: logFilePath)!
        }
        let time = Date().toString()
        let dataStirng = "<\(time)> [\(sourceFileName(filePath: className)) -> \(functionName) : <\(message)>] \n"
        
        if fileHandle == nil {
            fileHandle = FileHandle(forWritingAtPath: logFilePath)!
        }
        
        fileHandle?.truncateFile(atOffset: (fileHandle?.seekToEndOfFile())!)
        print(logFilePath)
        
        let data = dataStirng.data(using: String.Encoding.ascii, allowLossyConversion: true)
        
        fileHandle?.write(data!)
    }
    
    public class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    static func createBaseDirectory () {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let writePath = NSURL(fileURLWithPath: documentDirectory!).appendingPathComponent(logsFolder)
        let logPath = String(describing: writePath!)
        logFolderPath = logPath.replacingOccurrences(of: "file://", with: "")
        if !fileManager.fileExists(atPath: logFolderPath) {
            do{
                try fileManager.createDirectory(atPath: logFolderPath, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print(error)
            }
        }
    }
    
    static func getFileName() -> String? {
        
        let dateFormat = "dd-MM-yy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: Date())
        let fileName = date + ".txt"
        
        return fileName
    }
    
    public class func deleteOlderLogs(days: Int) {
        
        createBaseDirectory()
        let day: CGFloat = CGFloat(days)
        let fileManager = FileManager.default
        do {
            let contentsInFile = try fileManager.contentsOfDirectory(atPath: logFolderPath)
            let dateFormat = "dd-MM-yy"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            let dateString = dateFormatter.string(from: Date())
            let date = dateFormatter.date(from: dateString)
            let timeInterval = CGFloat(-1 * day * 24 * 60 * 60)
            let deleteDate = date?.addingTimeInterval(TimeInterval(timeInterval))
            
            for fileName in contentsInFile {
                let index = fileName.index(fileName.startIndex, offsetBy: 8)
                let dateString = fileName.substring(to: index)
                
                let fileDate = dateFormatter.date(from: dateString)
                
                if fileDate?.compare(deleteDate!) == .orderedAscending {
                    let fileWritePath = NSURL(fileURLWithPath: logFolderPath).appendingPathComponent(fileName)
                    let filePath = String(describing: fileWritePath!)
                    let logPath = filePath.replacingOccurrences(of: "file://", with: "")
                    
                    try fileManager.removeItem(atPath: logPath)
                }
            }
        } catch {
            print(error)
        }
    }
}

extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}

enum LogEvent: String {
    case e = "Error"
    case i = "Info"
    case d = "Degug"
    case w = "Warning"
}
