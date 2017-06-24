//
//  DataLayersProtocols.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

protocol FileFystemInteractionProtocol {
    //  Connection info is params to connect to remote database
    
    func getConnectionInfo() -> ConnectionInfo
    func saveConnectionInfo(info: ConnectionInfo) -> Bool
    //  Frequency of Accelerometer and Gyroscope sending
    func updateSendFrequency(sendFrequency: CGFloat) -> Bool
}

protocol TimeSeriesStorageProtocol {
    
    //  Adds new items to big storage
    func storeNewItems()
    func getDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel))
    //  Get temple records what will be stored by "storeNewItems:" method
    func getNewDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel))
    //  Adds records to storage
    func addAccelRecords(x: Double, y: Double, z: Double)
    //  Adds records to storage
    func addGyroRecords(x: Double, y: Double, z: Double)
    
}
