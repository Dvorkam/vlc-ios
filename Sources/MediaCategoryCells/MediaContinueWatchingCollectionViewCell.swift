//
//  MediaContinueWatchingCollectionViewCell.swift
//  VLC-iOS
//
//  Created by Pushpinder Pal Singh on 01/07/21.
//  Copyright © 2021 VideoLAN. All rights reserved.
//

import UIKit

class MediaContinueWatchingCollectionViewCell: BaseCollectionViewCell {

	@IBOutlet var thumbnailView: UIImageView!
	@IBOutlet var titleLabel: VLCMarqueeLabel!
	@IBOutlet var timeLeftLabel: VLCMarqueeLabel!

	override var media: VLCMLObject? {
		didSet {
			if let movie = media as? VLCMLMedia {
				titleLabel.text = movie.title()
				accessibilityLabel = movie.accessibilityText(editing: false)
				thumbnailView.layer.cornerRadius = 3
				thumbnailView.image = movie.thumbnailImage()
			}
		}
	}

    private var enableMarquee: Bool {
        return !UserDefaults.standard.bool(forKey: kVLCSettingEnableMediaCellTextScrolling)
    }

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		if #available(iOS 11.0, *) {
			thumbnailView.accessibilityIgnoresInvertColors = true
		}
		titleLabel.labelize = enableMarquee
		titleLabel?.textColor = PresentationTheme.current.colors.cellTextColor
	}

}
