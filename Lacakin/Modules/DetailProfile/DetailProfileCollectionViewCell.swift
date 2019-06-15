//
//  DetailProfileCollectionViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 22/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class DetailProfileCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension DetailProfileCollectionViewCell {
    func configureUser(model: ActivityListResponse?) {
        guard let model = model else { return }
        imagesView.image = UIImage(named: "bg_map")
        if model.photos?.count ?? 0 > 0 {
            let url = URL(string: model.photos?.first?.actphoPhotourl ?? "")
            imagesView.kf.setImage(with: url, placeholder: UIImage(named: "bg_map"))
        }
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        bgView.layer.cornerRadius = 8
        bgView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        imagesView.layer.cornerRadius = 8
        imagesView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        imagesView.clipsToBounds = true
        imagesView.contentMode = .scaleAspectFill
        nameLabel.text = model.actName
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        descLabel.text = model.actDesc ?? ""
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
        let actDate = Date(timeIntervalSince1970: TimeInterval(model.actDateTimeStart ?? 0))
        dateLabel.text = actDate.dateToStringNormal()
    }
    
    func configureFriend(model: FriendActivityResponse?) {
        guard let model = model else { return }
        imagesView.image = UIImage(named: "bg_map")
        if model.photos?.count ?? 0 > 0 {
            let url = URL(string: model.photos?.first?.actphoPhotourl ?? "")
            imagesView.kf.setImage(with: url, placeholder: UIImage(named: "bg_map"))
        }
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        bgView.layer.cornerRadius = 8
        bgView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        imagesView.layer.cornerRadius = 8
        imagesView.dropShadow(color: UIColor.transparantShadow, offset: CGSize(width: 0, height: 1), opacity: 1, radius: 4)
        imagesView.clipsToBounds = true
        imagesView.contentMode = .scaleAspectFill
        //        if model.flag == "owned" {
        //            nameLabel.text = model.actName
        //        } else if model.flag == "joined" {
        //            nameLabel.text = model.ownerName
        //        } else {
        //            nameLabel.text = model.ownerName
        //        }
        nameLabel.text = model.actName
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.layoutIfNeeded()
        descLabel.text = model.actDesc ?? ""
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
        let actDate = Date(timeIntervalSince1970: TimeInterval(model.actTimestamp ?? 0))
        dateLabel.text = actDate.dateToStringNormal()
    }
}
