//
//  MiniPlayerInfoCollectionViewFlowLayout.swift
//  VLC-iOS
//
//  Created by mohamed sliem on 01/07/2024.
//  Copyright © 2024 VideoLAN. All rights reserved.
//

import UIKit

class MiniPlayerInfoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        setItemSize()
    }

    private func setItemSize() {
        guard let itemSize = self.collectionView?.frame.size else { return }
        self.itemSize = itemSize
    }
}

