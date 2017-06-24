//
//  AccelerometerScreenVM.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

class AccelerometerScreenVM: NSObject {
    
    let connectionInfo = Variable<ConnectionInfo>(DataManagerAPI.shared.getConnectionInfo())
    
    func relaunch() {
        connectionInfo.value = DataManagerAPI.shared.getConnectionInfo()
    }
    
    //  Is called when Accelerometer or Gyroscope generates new value
    func dataChanged(accelX: Double, accelY: Double, accelZ: Double, gyroX: Double, gyroY: Double, gyroZ: Double) {
        DataManagerAPI.shared.addAccelRecords(x: accelX, y: accelY, z: accelZ)
        DataManagerAPI.shared.addGyroRecords(x: gyroX, y: gyroY, z: gyroZ)
    }
}
