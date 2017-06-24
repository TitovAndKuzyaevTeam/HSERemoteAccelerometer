//
//  ConnectionInfo.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class ConnectionInfo: NSObject, Mappable {
    
    var userName = ""
    var password = ""
    var dbName = ""
    var ipAddress = ""
    var sendFrequency = 0.5 as CGFloat// Out of 1. 1..5
    var lastSendDate = Date()
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userName <- map["user_name"]
        password <- map["password"]
        dbName <- map["db_name"]
        ipAddress <- map["ip_address"]
        sendFrequency <- map["send_frequency"]
        lastSendDate <- map["last_send_date"]
    }
    /*
    func toJSONString() -> String! {
        var jsonString = "{"
        jsonString += "\"user_name\":\"\(userName)\","
        jsonString += "\"password\":\"\(password)\","
        jsonString += "\"db_name\":\"\(dbName)\","
        jsonString += "\"ip_address\":\"\(ipAddress)\""
        return jsonString + "}"
    }
 */
}
