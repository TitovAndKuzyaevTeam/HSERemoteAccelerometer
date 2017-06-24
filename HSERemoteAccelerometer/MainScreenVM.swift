//
//  MainScreenVM.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift

class MainScreenVM: NSObject {

    let connectionInfo = Variable<ConnectionInfo>(DataManagerAPI.shared.getConnectionInfo())
    
    func relaunch() {
        connectionInfo.value = DataManagerAPI.shared.getConnectionInfo()
    }
    
    //  Update ConnectionInfo
    func updateInfo(withUserName userName: String) {
        let info = connectionInfo.value
        info.userName = userName
        _ = DataManagerAPI.shared.saveConnectionInfo(info: info)
        self.relaunch()
    }
    
    //  Update ConnectionInfo
    func updateInfo(withPassword password: String) {
        let info = connectionInfo.value
        info.password = password
        _ = DataManagerAPI.shared.saveConnectionInfo(info: info)
        self.relaunch()
    }
    
    //  Update ConnectionInfo
    func updateInfo(withDBName dbName: String) {
        let info = connectionInfo.value
        info.dbName = dbName
        _ = DataManagerAPI.shared.saveConnectionInfo(info: info)
        self.relaunch()
    }
    
    //  Update ConnectionInfo
    func updateInfo(withIPAddress ipAddress: String) {
        let info = connectionInfo.value
        info.ipAddress = ipAddress
        _ = DataManagerAPI.shared.saveConnectionInfo(info: info)
        self.relaunch()
    }
    
}
