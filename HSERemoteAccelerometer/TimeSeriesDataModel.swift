//
//  TimeSeriesDataModel.swift
//  HSERemoteAccelerometer
//
//  Created by Александр Кузяев 2 on 15/06/2017.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import Foundation

class TimeSeriesDataModel {

    private var data = [Double]()
    
    func getData() -> [Double] {
        let array = Array(data)
        return array
    }
    
    func addObject(object: Double) {
        if data.count >= 100 {
            data.remove(at: 0)
        }
        data.append(object)
    }
    
    func clearData() {
        data = [Double]()
    }
    
}
