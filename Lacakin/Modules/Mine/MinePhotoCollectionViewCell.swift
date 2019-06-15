//
//  MinePhotoCollectionViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 18/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class MinePhotoCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension MinePhotoCollectionViewCell {
    func configure(model: ActivityListPhoto?, count: Int, index: Int) {
        guard let model = model else { return }
        let url = URL(string: model.actphoPhotourl ?? "")
        self.activityImageView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        if index == 2 {
            bgView.isHidden = false
            let leftCount = count - 3
            if leftCount == 0 {
                countLabel.text = ""
            } else {
                countLabel.text = "+\(leftCount)"
            }
            
        } else {
            bgView.isHidden = true
        }
    }
}
