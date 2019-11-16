//
//  StandartTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class StandartTableViewCell: BaseTableViewCell {

    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension StandartTableViewCell {
    func configure(desc: String) {
        selectionStyle = .none
        descLabel.text = desc
        descLabel.numberOfLines = 0
        descLabel.sizeToFit()
        descLabel.layoutIfNeeded()
    }
}
