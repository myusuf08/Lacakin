//
//  ImageCollectionViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 25/05/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension ImageCollectionViewCell {
    func configure(url: String) {
        let url = URL(string: url)
        self.images.kf.setImage(with: url, placeholder: UIImage(named: ""))
        self.images.contentMode = .scaleAspectFill
        self.images.clipsToBounds = true
    }
}
