//
//  ActivityControlsTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ActivityControlsTableViewCell: BaseTableViewCell {

    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var publicImage: UIImageView!
    @IBOutlet weak var privateImage: UIImageView!
    @IBOutlet weak var yesImage: UIImageView!
    @IBOutlet weak var noImage: UIImageView!
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

extension ActivityControlsTableViewCell {
    func configure(isPublic: Bool, isJoin: Bool, disableNoButton: Bool) {
        if disableNoButton {
            noButton.isUserInteractionEnabled = false
        } else {
            noButton.isUserInteractionEnabled = true
        }
        selectionStyle = .none
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
        if isPublic {
            publicImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
            privateImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        } else {
            publicImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
            privateImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
        }
        if isJoin {
            yesImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
            noImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
        } else {
            yesImage.image = ImageConstant.dotUnselected.withRenderingMode(.alwaysTemplate)
            noImage.image = ImageConstant.dotSelected.withRenderingMode(.alwaysTemplate)
        }
        publicImage.tintColor = .defaultBlue
        privateImage.tintColor = .defaultBlue
        yesImage.tintColor = .defaultBlue
        noImage.tintColor = .defaultBlue
    }
}
