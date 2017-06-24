//
//  StoryboardHelper.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

struct Storyboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

class StoryboardHelper: NSObject {
    
    class func mainVC() -> MainTVC {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MainTVC") as! MainTVC
        return vc
    }
    
    class func accelerometerVC() -> AccelerometerVC {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "AccelerometerVC") as! AccelerometerVC
        return vc
    }
    
}
