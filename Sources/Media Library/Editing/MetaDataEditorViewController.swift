//
//  MetaDataEditorViewController.swift
//  VLC-iOS
//
//  Created by Eshan Singh on 11/06/24.
//  Copyright © 2024 VideoLAN. All rights reserved.
//

import Foundation

protocol metaDataViewDelegate {
    func metaDataNewInfo(meta: MetaDataType, value: String)
}

enum MetaDataType: CaseIterable {
    case title
    case artistName
    case albumName
    case genre
}

class MetaDataEditorViewController: UIViewController {
    
    var stackView = UIStackView()
    var submitButton = UIButton()
    var vlcConeImageView = UIImageView()
    var newValues = [MetaDataType : String]()
    
    var medias = [VLCMLMedia]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.title = "Audio Meta Data Editor"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        self.navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = .white
        setupSubmitButton()
        configureStackView()
        
        setStackViewConstraints()
        addButtonstoStackView()
        
        setupVlcConeImageView()
    }
    
    func setupSubmitButton() {
        submitButton.setTitle("Save", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .orange
        submitButton.layer.cornerRadius = 10
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
    }
    
    func addButtonstoStackView() {
        
        for meta in MetaDataType.allCases {
            let metaDataView = MetaDataEditorView(meta: meta)
            metaDataView.delegate = self
            stackView.addArrangedSubview(metaDataView)
        }
        
    }
    
   
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
        VLCAppCoordinator().mediaLibraryService.reload()
    }
    
    @objc func submitButtonTapped() {
      // Save the Values from Dictionary to the backend here
        if var media = medias.first {
            if let mainFile = media.mainFile() {
                let libVLCmedia = VLCMedia(url: mainFile.mrl)
                libVLCmedia.metaData.title = newValues[.title]
                libVLCmedia.metaData.album = newValues[.albumName]
                libVLCmedia.metaData.genre = newValues[.genre]
                libVLCmedia.metaData.albumArtist = newValues[.artistName]
                libVLCmedia.metaData.save()
                
            }
        }
        medias.removeAll()
        dismissView()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    func setupVlcConeImageView() {
        vlcConeImageView.image = UIImage(named: "Lunettes") // Make sure the image is in your assets
        vlcConeImageView.alpha = 0.5
        vlcConeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vlcConeImageView)
            
        NSLayoutConstraint.activate([
        vlcConeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        vlcConeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
        vlcConeImageView.widthAnchor.constraint(equalToConstant: 200),
        vlcConeImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension MetaDataEditorViewController: metaDataViewDelegate {
    func metaDataNewInfo(meta: MetaDataType, value: String) {
        print("Meta Data's \(meta) new value \(value)")
        newValues[meta] = value
    }
}
