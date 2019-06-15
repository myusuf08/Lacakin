//
//  NotificationsTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var nameDescLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NotificationsTableViewCell {
    func configure(model: MTQQNotificationRealm) {
        selectionStyle = .none
        let url = URL(string: model.icon)
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        nameDescLabel.text = "\(model.title) \(model.text)"
        nameDescLabel.numberOfLines = 0
        nameDescLabel.sizeToFit()
        nameDescLabel.layoutIfNeeded()
        let date = Date(timeIntervalSince1970: TimeInterval(Int(model.timestamp) ?? 0))
        timeLabel.text = date.timesAgo()
    }
}

