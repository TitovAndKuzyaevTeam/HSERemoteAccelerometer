//
//  NetworkManager.swift
//  HSERemoteAccelerometer
//
//  Created by Александр Кузяев 2 on 15/06/2017.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class NetworkManager {
    
    static let instance = NetworkManager()
    
    private let pretty = "true"
    
    //  Fetch request. Gett all data from InfluxDB
    func getData(withName name: String) {
        
        let query = "SELECT * FROM test"
        
        let connectionInfo = DataManagerAPI.shared.getConnectionInfo()
        let urlString = "http://\(connectionInfo.ipAddress)/query?pretty=\(pretty)&u=\(connectionInfo.userName)&p=\(connectionInfo.password)&db=\(connectionInfo.dbName)&q=\(query)"
        
        Alamofire.request(urlString).responseJSON { (data) in
            print(data)
        }
        
    }
    
    //  POST request. Push all temple records to InfluxDB
    func sendData(withName name: String, accelX: TimeSeriesDataModel, accelY: TimeSeriesDataModel, accelZ: TimeSeriesDataModel, gyroX: TimeSeriesDataModel, gyroY: TimeSeriesDataModel, gyroZ: TimeSeriesDataModel) {
        
        let connectionInfo = DataManagerAPI.shared.getConnectionInfo()
        let urlString = "http://\(connectionInfo.ipAddress)/write?pretty=\(pretty)&u=\(connectionInfo.userName)&p=\(connectionInfo.password)&db=\(connectionInfo.dbName)"
        
        let arrayAccelX = accelX.getData()
        let arrayAccelY = accelY.getData()
        let arrayAccelZ = accelZ.getData()
        
        let arrayGyroX = gyroX.getData()
        let arrayGyroY = gyroY.getData()
        let arrayGyroZ = gyroZ.getData()
        
        for i in 0..<arrayAccelX.count {
            if arrayAccelY.count > i && arrayAccelZ.count > i && arrayGyroX.count > i && arrayGyroY.count > i && arrayGyroZ.count > i {
                let bodyString = "test,tag=A accelX=\(arrayAccelX[i]),accelY=\(arrayAccelY[i]),accelZ=\(arrayAccelZ[i]),gyroX=\(arrayGyroX[i]),gyroY=\(arrayGyroY[i]),gyroZ=\(arrayGyroZ[i])"
                
                Alamofire.request(urlString, method: .post, parameters: [:], encoding: bodyString, headers: [:]).responseJSON { (data) in
                    print(data)
                }
            }
        }
    }
    
}
