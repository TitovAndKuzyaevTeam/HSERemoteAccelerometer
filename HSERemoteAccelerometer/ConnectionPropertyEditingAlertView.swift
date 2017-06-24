//
//  ConnectionPropertyEditingAlertView.swift
//  HSERemoteAccelerometer
//
//  Created by Dmitrii Titov on 12.06.17.
//  Copyright © 2017 Dmitriy Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

class ConnectionPropertyEditingAlertView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let valueTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "value"
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        return tf
    }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    let cancelButton: AlertButton = {
        let button = AlertButton()
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    let saveButton: AlertButton = {
        let button = AlertButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    weak var delegate: DTAlertViewContainerProtocol?
    var requiredHeight = 90.0 as CGFloat
    var frameToFocus = CGRect.zero
    var needToFocus = false
    
    var saveAction: ((String) -> ())?
    
    init(title: String, value: String, saveAction: @escaping ((String) -> ())) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueTextField.text = value
        self.saveAction = saveAction
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        for view in [backgroundView,
                     titleLabel,
                     valueTextField,
                     cancelButton,
                     saveButton] {
            self.addSubview(view)
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
}

extension ConnectionPropertyEditingAlertView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let segment2Height = 35.0 as CGFloat
        let segment1Height = self.frame.height - segment2Height
        let horisontalOffset = 15.0 as CGFloat
        let buttonsHorisontalOffset = 20.0 as CGFloat
        let height = 32.0 as CGFloat
        let width = self.frame.size.width / 2 - horisontalOffset * 2
        let buttonsWidth = self.frame.size.width / 2 - buttonsHorisontalOffset * 2
        titleLabel.frame = CGRect(x: horisontalOffset, y: (segment1Height - height) / 2, width: width, height: height)
        valueTextField.frame = CGRect(x: self.frame.size.width - width - horisontalOffset, y: (segment1Height - height) / 2, width: width, height: height)
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: segment1Height)
        
        cancelButton.frame = CGRect(x: buttonsHorisontalOffset, y: segment1Height + (segment1Height - height) / 2, width: buttonsWidth, height: height)
        saveButton.frame = CGRect(x: self.frame.size.width - buttonsWidth - buttonsHorisontalOffset, y: segment1Height + (segment1Height - height) / 2, width: buttonsWidth, height: height)
    }
    
}

extension ConnectionPropertyEditingAlertView: DTAlertViewProtocol {
    
    func backgroundPressed() {
        self.cancelButtonPressed()
    }
    
}

extension ConnectionPropertyEditingAlertView { // MARK: Actions
    
    @objc func cancelButtonPressed() {
        valueTextField.resignFirstResponder()
        delegate?.dismiss()
    }
    
    @objc func saveButtonPressed() {
        valueTextField.resignFirstResponder()
        if saveAction != nil {
            saveAction!(valueTextField.text!)
        }
        delegate?.dismiss()
    }
    
}
