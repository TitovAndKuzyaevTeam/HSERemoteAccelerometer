//
//  AlertButton.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit

class AlertButton: UIButton {

    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor(white: 1, alpha: 1)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
