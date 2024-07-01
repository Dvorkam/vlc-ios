//
//  MetaDataEditorView.swift
//  VLC-iOS
//
//  Created by Eshan Singh on 12/06/24.
//  Copyright © 2024 VideoLAN. All rights reserved.
//

import Foundation
import UIKit

class MetaDataEditorView: UIView {
    
    var label: UILabel
    var textField: UITextField
    var metaDataType: MetaDataType
    var delegate: metaDataViewDelegate?

    init(meta: MetaDataType) {
        self.metaDataType = meta
        self.label = UILabel()
        self.textField = UITextField()
        super.init(frame: .zero)
        setupView()
        setupOrientationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        label.text = returnLabelText(meta: metaDataType)
        
        updateLabelFont()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Enter New Value"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        addSubview(label)
        addSubview(textField)
        setupConstraints()
    }
    
    private func updateLabelFont() {
        let device = UIDevice.current
        let isIpad = device.userInterfaceIdiom == .pad
        
        if device.orientation == .portrait || device.orientation == .portraitUpsideDown {
            label.font = isIpad ? UIFont.italicSystemFont(ofSize: 30) : UIFont.italicSystemFont(ofSize: 20)
        } else {
            label.font = isIpad ? UIFont.italicSystemFont(ofSize: 20) : UIFont.italicSystemFont(ofSize: 10)
        }
    }
    
    private func setupOrientationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func handleOrientationChange() {
        DispatchQueue.main.async {
            self.updateLabelFont()
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.deactivate(self.constraints)
        
        if !UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            ])
        } else {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            ])
        }
    }
    
    private func returnLabelText(meta: MetaDataType) -> String {
        switch meta {
        case .title:
            return "Song's Title:"
        case .albumName:
            return "Song's Album Name:"
        case .artistName:
            return "Song's Artist Name:"
        case .genre:
            return "Song's Genre Name:"
        }
    }
}

extension MetaDataEditorView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.metaDataNewInfo(meta: metaDataType, value: textField.text ?? "")
    }
}

