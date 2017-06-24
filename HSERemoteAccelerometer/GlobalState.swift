//
//  GlobalState.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 15.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDateTools

private let sharedInstance = GlobalState()
private let uuidName = UUID().uuidString

class GlobalState: NSObject {
    
    //  Singleton getter
    class var shared : GlobalState {
        return sharedInstance
    }
    
    fileprivate let disposeBag = DisposeBag()   //  It is needed for RxSwift usage
    
    fileprivate var timeToSendTimer: Timer?
    
    var lastSendDate = DataManagerAPI.shared.getConnectionInfo().lastSendDate   //  The time of last sending records to InfluxDB
    
    override init() {
        super.init()
        
        self.setup()
        self.initBidings()
    }
    
    fileprivate let minSendPeriod = 4.0 as Double   //  Minimum sending frequency
    fileprivate let maxSendPeriod = 50.0 as Double  //  Maximum sending frequency
    let sendingFrequency = Variable<Double>(0.5) // 0..1. Seconds out of maxSendPeriod
    let sendingFrequencyInSeconds = Variable<Double>(0.5)   //  = minSendPeriod + (maxSendPeriod - minSendPeriod) * sendingFrequency
    
    let timeToSend = Variable<CGFloat>(0) // Seconds to send
    let timeToSendPercentage = Variable<CGFloat>(0) // Seconds to send out of maxSendPeriod
    
    fileprivate func setup() {
        self.startTimer(true)
    }
    
    fileprivate func initBidings() {
        
        _ = sendingFrequency.asObservable()
            .map({ [weak self] (sendingFrequency) -> Double in
                guard let weakSelf = self else { return 0}
                return Double(weakSelf.minSendPeriod) + Double(weakSelf.maxSendPeriod - weakSelf.minSendPeriod) * Double(weakSelf.sendingFrequency.value)
            })
            .bind(to: self.sendingFrequencyInSeconds)
            .addDisposableTo(disposeBag)
        
        _ = timeToSend.asObservable()
            .map({ [weak self] (timeToSend) -> CGFloat in
                guard let weakSelf = self else { return 0}
                return (CGFloat(weakSelf.sendingFrequencyInSeconds.value) - timeToSend) / CGFloat(weakSelf.sendingFrequencyInSeconds.value)
            })
            .map({ (timeToSend) -> CGFloat in
                if timeToSend < 0 { return 0
                }else if timeToSend > 1 { return 1
                }else { return timeToSend }
            })
            .bind(to: self.timeToSendPercentage)
            .addDisposableTo(disposeBag)
        
    }
    
    fileprivate func startTimer(_ start: Bool) {
        if start {
            timeToSendTimer = Timer(timeInterval: 0.02, target: self, selector: #selector(timerInteraction), userInfo: nil, repeats: true)
            RunLoop.current.add(timeToSendTimer!, forMode: .defaultRunLoopMode)
        } else {
            if let timeToSendTimer = timeToSendTimer {
                timeToSendTimer.invalidate()
            }
        }
    }
    
    @objc fileprivate func timerInteraction() {
        let currentDate = Date()
        let destDate = NSDate(timeInterval: TimeInterval(floatLiteral: minSendPeriod + (maxSendPeriod - minSendPeriod) * sendingFrequency.value), since: lastSendDate) as Date
        if currentDate > destDate as Date {
            self.send()
        }else{
            self.timeToSend.value = CGFloat(destDate.secondsFrom(date: currentDate))
        }
    }
    
    func send() {
        //  Temple records
        let items = DataManagerAPI.shared.getNewDataModels()
        let accelDataModels = items.accel
        let gyroDataModels = items.gyro
        //  Send the temple records to InfluxDB
        NetworkManager.instance.sendData(withName: uuidName, accelX: accelDataModels.x, accelY: accelDataModels.y, accelZ: accelDataModels.z, gyroX: gyroDataModels.x, gyroY: gyroDataModels.y, gyroZ: gyroDataModels.z)
        DataManagerAPI.shared.storeNewItems()
        let info = DataManagerAPI.shared.getConnectionInfo()
        info.lastSendDate = Date()
        if !DataManagerAPI.shared.saveConnectionInfo(info: info) {
            print()
        }
        self.lastSendDate = DataManagerAPI.shared.getConnectionInfo().lastSendDate
        self.timeToSend.value = CGFloat(maxSendPeriod * sendingFrequency.value)
    }
    
}
