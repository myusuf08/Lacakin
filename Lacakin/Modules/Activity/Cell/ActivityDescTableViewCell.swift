//
//  ActivityDescTableViewCell.swift
//  Lacakin
//
//  Created by Muhammad Yusuf on 20/01/19.
//  Copyright © 2019 Gamatechno. All rights reserved.
//

import UIKit

class ActivityDescTableViewCell: BaseTableViewCell {

    @IBOutlet weak var descTextView: UITextView!
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

extension ActivityDescTableViewCell {
    func configure(isEdit: Bool) {
        selectionStyle = .none
        descTextView.delegate = self
        if !isEdit {
            descTextView.text = "Add Description..."
            descTextView.textColor = UIColor.lightGray
        }
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.15).cgColor
    }
}

extension ActivityDescTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Description..."
            textView.textColor = UIColor.lightGray
        }
    }
}
