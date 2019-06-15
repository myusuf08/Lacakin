//
//  ActivityLocationTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ActivityLocationTableViewCell: BaseTableViewCell {

    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
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

extension ActivityLocationTableViewCell {
    func configure(location: String) {
        selectionStyle = .none
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        locationTextField.text = location
    }
}
