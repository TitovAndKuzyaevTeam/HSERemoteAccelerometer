//
//  AccelerometerVC.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import CoreMotion
import RxSwift
import Charts
import RxCocoa

class AccelerometerVC: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var labelAccelX: UILabel!
    @IBOutlet weak var labelAccelY: UILabel!
    @IBOutlet weak var labelAccelZ: UILabel!
    @IBOutlet weak var labelGyroX: UILabel!
    @IBOutlet weak var labelGyroY: UILabel!
    @IBOutlet weak var labelGyroZ: UILabel!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var willBeSendAfterValueLabel: UILabel!
    
    @IBOutlet weak var timeToSendProgressView: UIProgressView!
    @IBOutlet weak var timeToSendSlider: UISlider!
    @IBOutlet weak var lineChartAccelView: LineChartView!
    @IBOutlet weak var lineChartGyroView: LineChartView!
    
    private var accelX: Double = 0.0
    private var accelY: Double = 0.0
    private var accelZ: Double = 0.0
    private var gyroX: Double = 0.0
    private var gyroY: Double = 0.0
    private var gyroZ: Double = 0.0
    
    private let motionManager = CMMotionManager()
    
    let vm = AccelerometerScreenVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setup() {
        
        setupAccelerometer()
        setupGyroscope()
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        timeToSendSlider.setValue(Float(vm.connectionInfo.value.sendFrequency), animated: true)
        setupCharts()
    }
    
    func initBindings() {
        
        //  Bind sendingFrequencyInSeconds to frequencyLabel
        _ = GlobalState.shared.sendingFrequencyInSeconds.asObservable()
            .map({ String.init(format: "%.2f sec", $0) })
            .bind(to: self.frequencyLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        //  Bind timeToSend to willBeSendAfterValueLabel
        _ = GlobalState.shared.timeToSend.asObservable()
            .map({ String.init(format: "%.1f sec", $0) })
            .bind(to: self.willBeSendAfterValueLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        //  Subscribe on timeToSend
        _ = GlobalState.shared.timeToSend.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                guard let weakSelf = self else { return }
                weakSelf.setupCharts()
            })
            .addDisposableTo(disposeBag)
        
        //  Bind timeToSendSlider to sendingFrequency
        _ = timeToSendSlider.rx.value
            .filter({ DataManagerAPI.shared.updateSendFrequency(sendFrequency: CGFloat($0)) })
            .map({ Double($0) })
            .bind(to: GlobalState.shared.sendingFrequency)
            .addDisposableTo(disposeBag)
        
        _ = GlobalState.shared.timeToSendPercentage.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (timeToSendPercentage) in
                self.timeToSendProgressView.setProgress(Float(timeToSendPercentage), animated: false)
            })
            .addDisposableTo(disposeBag)
        
    }
    
    private func setupAccelerometer() {
        
        motionManager.accelerometerUpdateInterval = 0.1
        
        if motionManager.isAccelerometerAvailable {
            
            let queue = OperationQueue()
            
            motionManager.startAccelerometerUpdates(to: queue, withHandler: { (data, error) in
                
                if error == nil {
                    if let accelData = data {
                        
                        DispatchQueue.main.async { [unowned self] in
                            self.labelAccelX.text = String(format: "%.2f", accelData.acceleration.x)
                            self.labelAccelY.text = String(format: "%.2f", accelData.acceleration.y)
                            self.labelAccelZ.text = String(format: "%.2f", accelData.acceleration.z)
                            
                            self.accelX = accelData.acceleration.x
                            self.accelY = accelData.acceleration.y
                            self.accelZ = accelData.acceleration.z
                            
                            self.vm.dataChanged(accelX: self.accelX, accelY: self.accelY, accelZ: self.accelZ, gyroX: self.gyroX, gyroY: self.gyroY, gyroZ: self.gyroZ)
                        }
                        
                    } else {
                        print("Accelerometer Data Error")
                    }
                } else {
                    print("Error \(error!.localizedDescription)")
                }
                
            })
            
        }
    }
    
    private func setupGyroscope() {
        
        motionManager.gyroUpdateInterval = 0.1
        
        if motionManager.isGyroAvailable {
            
            let queue = OperationQueue()
            
            motionManager.startGyroUpdates(to: queue, withHandler: { (data, error) in
                
                if error == nil {
                    if let gyroData = data {
                        
                        DispatchQueue.main.async { [unowned self] in
                            self.labelGyroX.text = String(format: "%.2f", gyroData.rotationRate.x)
                            self.labelGyroY.text = String(format: "%.2f", gyroData.rotationRate.y)
                            self.labelGyroZ.text = String(format: "%.2f", gyroData.rotationRate.z)
                            
                            self.gyroX = gyroData.rotationRate.x
                            self.gyroY = gyroData.rotationRate.y
                            self.gyroZ = gyroData.rotationRate.z
                            
                            self.vm.dataChanged(accelX: self.accelX, accelY: self.accelY, accelZ: self.accelZ, gyroX: self.gyroX, gyroY: self.gyroY, gyroZ: self.gyroZ)
                        }
                        
                    } else {
                        print("Gyroscope Data Error")
                    }
                } else {
                    print("Error \(error!.localizedDescription)")
                }
                
            })
            
        } else {
            
            // Show alert
            
        }
    }
    
    private func generateDataEntries(units: [Double]) -> [ChartDataEntry] {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<units.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: units[i])
            dataEntries.append(dataEntry)
        }
        
        return dataEntries
    }
    
    private func setupCharts() {
        //  Update Charts data
        setupChartAccel()
        setupChartGyro()
    }
    
    private func setupChartAccel() {
        
        lineChartAccelView.noDataText = "Ожидание данных"
        
        let records = DataManagerAPI.shared.getDataModels()
        let chartDataAccelX = LineChartDataSet(values: generateDataEntries(units: records.accel.x.getData()), label: "AccelX")
        let chartDataAccelY = LineChartDataSet(values: generateDataEntries(units: records.accel.y.getData()), label: "AccelY")
        let chartDataAccelZ = LineChartDataSet(values: generateDataEntries(units: records.accel.z.getData()), label: "AccelZ")
        
        let dataSets = [chartDataAccelX, chartDataAccelY, chartDataAccelZ]
        
        let gradientColors = [UIColor.green.cgColor, UIColor.clear.cgColor] as CFArray
        let gradientLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: gradientLocations) else {
            return
        }
        
        let colors = [UIColor.green,
                      UIColor.black,
                      UIColor.blue]
        for (dataSet, color) in zip(dataSets, colors)  {
            dataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
            dataSet.drawCirclesEnabled = false
            dataSet.colors = [color]
        }
        
        let chartData = LineChartData(dataSets: dataSets)
        lineChartAccelView.chartDescription?.text = ""
        lineChartAccelView.data = chartData
        
    }
    
    private func setupChartGyro() {
        
        lineChartGyroView.noDataText = "Ожидание данных"
        
        let records = DataManagerAPI.shared.getDataModels()
        let chartDataGyroX = LineChartDataSet(values: generateDataEntries(units: records.gyro.x.getData()), label: "GyroX")
        let chartDataGyroY = LineChartDataSet(values: generateDataEntries(units: records.gyro.y.getData()), label: "GyroY")
        let chartDataGyroZ = LineChartDataSet(values: generateDataEntries(units: records.gyro.z.getData()), label: "GyroZ")
        
        let dataSets = [chartDataGyroX, chartDataGyroY, chartDataGyroZ]
        
        let colors = [UIColor.green,
                      UIColor.black,
                      UIColor.blue]
        for (dataSet, color) in zip(dataSets, colors)  {
            dataSet.drawCirclesEnabled = false
            dataSet.drawFilledEnabled = false
            dataSet.colors = [color]
        }
        
        let chartData = LineChartData(dataSets: dataSets)
        lineChartGyroView.chartDescription?.text = ""
        lineChartGyroView.data = chartData
        
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        GlobalState.shared.send()
    }
    
}
