//
//  DataManagerAPI.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

private let sharedInstance = DataManagerAPI()

class DataManagerAPI: NSObject {
    
    //  Singleton getter
    class var shared : DataManagerAPI {
        return sharedInstance
    }
    
    //  Interact with File what keeps connection info (Username, dbname, password, ip address)
    fileprivate let fileSystemIteractor: FileFystemInteractionProtocol = FileSystemIteractor()
    //  Store records from Accelerometer and Gyroscope
    fileprivate let timeSeriesStorage: TimeSeriesStorageProtocol = TimeSeriesModelsStorage()
    
}

extension DataManagerAPI: FileFystemInteractionProtocol {
    
    func getConnectionInfo() -> ConnectionInfo {
        return fileSystemIteractor.getConnectionInfo()
    }
    
    func saveConnectionInfo(info: ConnectionInfo) -> Bool {
        return fileSystemIteractor.saveConnectionInfo(info: info)
    }
    
    func updateSendFrequency(sendFrequency: CGFloat) -> Bool {
        return fileSystemIteractor.updateSendFrequency(sendFrequency: sendFrequency)
    }
    
}

extension DataManagerAPI: TimeSeriesStorageProtocol {
    
    func storeNewItems() {
        timeSeriesStorage.storeNewItems()
    }
    
    func getDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel)) {
            return timeSeriesStorage.getDataModels()
    }
    
    func getNewDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel)) {
            return timeSeriesStorage.getNewDataModels()
    }
    
    func addAccelRecords(x: Double, y: Double, z: Double) {
        timeSeriesStorage.addAccelRecords(x: x, y: y, z: z)
    }
    
    func addGyroRecords(x: Double, y: Double, z: Double) {
        timeSeriesStorage.addGyroRecords(x: x, y: y, z: z)
    }
    
}
