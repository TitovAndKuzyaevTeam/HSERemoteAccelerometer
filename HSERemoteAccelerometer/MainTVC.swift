//
//  MainTVC.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer
import RxSwift

class MainTVC: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    let vm = MainScreenVM()
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var dbNameLabel: UILabel!
    @IBOutlet weak var ipAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func initBindings() {
        _ = vm.connectionInfo.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (info) in
                guard let weakSelf = self else { return }
                weakSelf.userNameLabel.text = info.userName
                weakSelf.passwordLabel.text = String(info.password.characters.map({ _ in "•" }))
                weakSelf.dbNameLabel.text = info.dbName
                weakSelf.ipAddressLabel.text = info.ipAddress
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func presentEditUserName() {
        let av = ConnectionPropertyEditingAlertView(title: "User name", value: vm.connectionInfo.value.userName) { (value) in
            self.vm.updateInfo(withUserName: value)
        }
        self.presentAlertView(alertView: av)
    }
    
    fileprivate func presentEditPassword() {
        let av = ConnectionPropertyEditingAlertView(title: "Password", value: vm.connectionInfo.value.password) { (value) in
            self.vm.updateInfo(withPassword: value)
        }
        av.valueTextField.isSecureTextEntry = true
        self.presentAlertView(alertView: av)
    }
    
    fileprivate func presentEditDBName() {
        let av = ConnectionPropertyEditingAlertView(title: "DB name", value: vm.connectionInfo.value.dbName) { (value) in
            self.vm.updateInfo(withDBName: value)
        }
        self.presentAlertView(alertView: av)
    }
    
    fileprivate func presentEditIPAddress() {
        let av = ConnectionPropertyEditingAlertView(title: "IP Adress", value: vm.connectionInfo.value.ipAddress) { (value) in
            self.vm.updateInfo(withIPAddress: value)
        }
        self.presentAlertView(alertView: av)
    }
    
    fileprivate func presentAlertView(alertView: ConnectionPropertyEditingAlertView) {
        let vc = DTAlertViewContainerController()
        alertView.valueTextField.autocapitalizationType = .none
        vc.presentOverVC(self, alert: alertView, appearenceAnimation: .fromTop, completion: nil)
    }
    
}

extension MainTVC { // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            Router.shared.showAccelerometerScreen()
            break
        case 1:
            switch indexPath.row {
            case 0:
                self.presentEditUserName()
                break
            case 1:
                self.presentEditPassword()
                break
            case 2:
                self.presentEditDBName()
                break
            case 3:
                self.presentEditIPAddress()
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
}
