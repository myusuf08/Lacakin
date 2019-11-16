//
//  DetailEventCollectionViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 16/06/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class DetailEventCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quotaLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: EventPackages) {
        bgView.layer.cornerRadius = 8
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        titleLabel.text = model.packageName ?? ""
        descLabel.text = model.packageDesc ?? ""
        let price = "\(model.packagePrice ?? 0)"
        if price == "0" {
            priceLabel.text = "Free"
        } else {
            let filterPrice = price.dropLast(3)
            priceLabel.text = "\(filterPrice)K"
        }
        quotaLabel.text = "Quota: \(model.packageQuota ?? 0) People"
    }
}
