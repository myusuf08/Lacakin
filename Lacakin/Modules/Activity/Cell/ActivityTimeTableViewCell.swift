//
//  ActivityTimeTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ActivityTimeTableViewCell: BaseTableViewCell {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ActivityTimeTableViewCell {
    func configure(date: String, time: String) {
        selectionStyle = .none
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        dateButton.setTitle(date, for: .normal)
        timeButton.setTitle(time, for: .normal)
    }

}
