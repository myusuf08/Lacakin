//
//  ActivityTitleTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ActivityTitleTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
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

extension ActivityTitleTableViewCell {
    func configure() {
        selectionStyle = .none
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
    }
}
