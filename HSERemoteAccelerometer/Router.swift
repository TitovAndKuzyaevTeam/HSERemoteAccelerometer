//
//  Router.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

private let sharedInstance = Router()

class Router: NSObject {
    
    class var shared : Router {
        return sharedInstance
    }

    let mainNC: UINavigationController = {
        let vc = StoryboardHelper.mainVC()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }()
    
    func showAccelerometerScreen() {
        let vc = StoryboardHelper.accelerometerVC()
        mainNC.pushViewController(vc, animated: true)
    }
    
}
