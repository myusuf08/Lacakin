//
//  NearbyTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 24/04/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit
import Kingfisher

class NearbyTableViewCell: BaseTableViewCell {

    var messageDidTap: (() -> Void)?
    var callDidTap: (() -> Void)?
    var locationDidTap: (() -> Void)?
    @IBOutlet weak var imagesView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var separatorViewTop: UIView!
    @IBOutlet weak var separatorViewBottom: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension NearbyTableViewCell {
    func configure(model: ListNearbyResponse?) {
        guard let model = model else { return }
        let url = URL(string: model.photo ?? "")
        imagesView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        nameLabel.text = model.name ?? ""
        let date = Date(timeIntervalSince1970: TimeInterval(Int(model.tm ?? "") ?? 0))
        dateLabel.text = date.dateToStringComment()
        let dist = Int(model.dist ?? 0) / 1000
        if Int(model.dist ?? 0) < 1000 {
            kmLabel.text = "\(Int(model.dist ?? 0)) meter"
        } else {
            kmLabel.text = "\(dist) km"
        }
        messageButton.addTarget(self, action: #selector(message), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(call), for: .touchUpInside)
        locationButton.addTarget(self, action: #selector(location), for: .touchUpInside)
    }
    
    @objc func message() {
        messageDidTap?()
    }
    
    @objc func call() {
        callDidTap?()
    }
    
    @objc func location() {
        locationDidTap?()
    }
}

