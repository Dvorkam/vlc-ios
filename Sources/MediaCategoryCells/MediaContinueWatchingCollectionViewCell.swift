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
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
