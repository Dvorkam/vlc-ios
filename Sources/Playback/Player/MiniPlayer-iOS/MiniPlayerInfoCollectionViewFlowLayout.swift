//
//  MiniPlayerInfoCollectionViewFlowLayout.swift
//  VLC-iOS
//
//  Created by mohamed sliem on 01/07/2024.
//  Copyright © 2024 VideoLAN. All rights reserved.
//

import UIKit

class MiniPlayerInfoCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var previousPage: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        setItemSize()
    }

    private func setItemSize() {
        guard let itemSize = self.collectionView?.frame.size else { return }
        self.itemSize = itemSize
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let pageWidth = self.itemSize.width + self.minimumInteritemSpacing
        let approximatePage = collectionView.contentOffset.x / pageWidth

        let currentPage: CGFloat
        if velocity.x == 0 {
            currentPage = round(approximatePage)
        } else if velocity.x < -0.4 {
            currentPage = floor(approximatePage)
        } else if velocity.x > 0.4 {
            currentPage = ceil(approximatePage)
        } else {
            currentPage = previousPage
        }

        previousPage = currentPage
        
        let newHorizontalOffset = (currentPage * pageWidth) - collectionView.contentInset.left
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    
}

