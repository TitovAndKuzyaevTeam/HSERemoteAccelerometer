//
//  FileFystemIteractor.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

class FileSystemIteractor: NSObject {
    
    fileprivate let encoding: String.Encoding = .utf8
    
}

extension FileSystemIteractor: FileFystemInteractionProtocol {
    
    func getConnectionInfo() -> ConnectionInfo {
        guard let fileHandle = self.fileHandleForRead() else {
            return ConnectionInfo()
        }
        guard let contentSting = String(data: fileHandle.readDataToEndOfFile(), encoding: encoding) else {
            fileHandle.closeFile()
            return ConnectionInfo()
        }
        guard let info = ConnectionInfo(JSONString: contentSting) else {
            fileHandle.closeFile()
            return ConnectionInfo()
        }
        fileHandle.closeFile()
        return info
    }
    
    func saveConnectionInfo(info: ConnectionInfo) -> Bool {
        guard let fileHandle = self.fileHandleForUpdation() else { return false }
        guard let jsonString = info.toJSONString() else {
            fileHandle.closeFile()
            return false
        }
        guard let data = jsonString.data(using: encoding) else {
            fileHandle.closeFile()
            return false
        }
        fileHandle.truncateFile(atOffset: 0)
        fileHandle.write(data)
        fileHandle.closeFile()
        return true
    }
    
    func updateSendFrequency(sendFrequency: CGFloat) -> Bool {
        let info = self.getConnectionInfo()
        info.sendFrequency = sendFrequency
        return self.saveConnectionInfo(info: info)
    }
    
}

extension FileSystemIteractor { // MARK: Helpers
    
    //  Path to the local file what contains info about connection
    fileprivate func filePath() -> String {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return filePath + "/" + "InfluxConnectionInformation.txt"
    }
    
    fileprivate func fileHandleForRead() -> FileHandle? {
        let filePath = self.filePath()
        if !FileManager.default.fileExists(atPath: filePath) {
            if !self.createFile(filePath: filePath) { return nil }
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else { return nil }
        return fileHandle
    }
    
    fileprivate func fileHandleForUpdation() -> FileHandle? {
        let filePath = self.filePath()
        if !FileManager.default.fileExists(atPath: filePath) {
            if !self.createFile(filePath: filePath) { return nil }
        }
        guard let fileHandle = FileHandle(forUpdatingAtPath: filePath) else { return nil }
        return fileHandle
    }
    
    //  Creates file what contains info about connection. Creates once with app's first launch
    fileprivate func createFile(filePath: String) -> Bool {
        let defaultInfo = ConnectionInfo()
        guard let jsonString = defaultInfo.toJSONString() else { return false }
        if FileManager.default.createFile(atPath: filePath, contents: jsonString.data(using: encoding), attributes: [:]) { return true
        }else{ return false }
    }
    
}
