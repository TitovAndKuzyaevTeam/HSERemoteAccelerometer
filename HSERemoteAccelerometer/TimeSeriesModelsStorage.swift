//
//  TimeSeriesModelsStorage.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 23.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

class TimeSeriesModelsStorage: NSObject {
    
    //  Stored Accelerometer & Gyroscope records. They are stored while app is launched
    var accelDataModels = (x: TimeSeriesDataModel(), y: TimeSeriesDataModel(), z: TimeSeriesDataModel())
    var gyroDataModels = (x: TimeSeriesDataModel(), y: TimeSeriesDataModel(), z: TimeSeriesDataModel())
    
    //  Temple records what are merged into accelDataModels & gyroDataModels arrays after been pushed to server
    var accelDataModelsNew = (x: TimeSeriesDataModel(), y: TimeSeriesDataModel(), z: TimeSeriesDataModel())
    var gyroDataModelsNew = (x: TimeSeriesDataModel(), y: TimeSeriesDataModel(), z: TimeSeriesDataModel())
    
}

extension TimeSeriesModelsStorage: TimeSeriesStorageProtocol {
    
    func storeNewItems() {
        self.mergeNewRecordsToStorage()
    }
    
    func getDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel)) {
            return (accelDataModels, gyroDataModels)
    }
    
    func getNewDataModels() -> (accel: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel),
        gyro: (x: TimeSeriesDataModel, y: TimeSeriesDataModel, z: TimeSeriesDataModel)) {
            return (accelDataModelsNew, gyroDataModelsNew)
    }
    
    func addAccelRecords(x: Double, y: Double, z: Double) {
        accelDataModels.x.addObject(object: x)
        accelDataModels.y.addObject(object: y)
        accelDataModels.z.addObject(object: z)
    }
    
    func addGyroRecords(x: Double, y: Double, z: Double) {
        gyroDataModels.x.addObject(object: x)
        gyroDataModels.y.addObject(object: y)
        gyroDataModels.z.addObject(object: z)
    }
    
}

extension TimeSeriesModelsStorage { // MARK: Helpers
    
    //  Clears temple records and stores it into accelDataModels & gyroDataModels arrays
    fileprivate func mergeNewRecordsToStorage() {
        for (new, storage) in zip([accelDataModelsNew, gyroDataModelsNew], [accelDataModels, gyroDataModels]) {
            for x in new.x.getData() {
                storage.x.addObject(object: x)
            }
            for y in new.y.getData() {
                storage.y.addObject(object: y)
            }
            for z in new.z.getData() {
                storage.z.addObject(object: z)
            }
            for dimention in [new.x, new.y, new.z] {
                dimention.clearData()
            }
        }
    }
    
}
